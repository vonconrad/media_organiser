module MediaOrganiser
  class Directory
    attr_accessor :name, :path

    def initialize(path)
      self.path = path
      self.name = ::File.basename(path)
    end

    def rename
      if name == 'Sample'
        puts "  DEL DIR '#{name}'"
        FileUtils.rm_rf(path) unless dry_run?
      else
        puts
        puts "RN DIR '#{name}' => '#{new_name}'"

        unless dry_run?
          ::File.rename(path, path.sub(name, new_name))
          self.path = path.sub(name, new_name)
        end

        rename_files
      end
    end

    def files
      Dir.new(path).reject{ |f| f == '.' || f == '..' }.map{ |f| "#{path}/#{f}" }.map do |f|
        ::File.directory?(f) ? Directory.new(f) : File.new(f)
      end
    end

    def rename_files
      files.each(&:rename)

      puts "  WRT META DATA"
      write_meta_data unless dry_run? || CLI.options.skip_metadata?
    end

    def title
      Data.get_title(name)
    end

    def year
      Data.get_year(name)
    end

    def new_name
      [title, (year ? year.wrap('()') : nil)].compact.join(' ')
    end

    def write_meta_data
      info = case
        when CLI.options.movie?
          vid = files.reject { |f| f.class == self.class }.find(&:video_file?) or return
          sub = files.reject { |f| f.class == self.class }.any?(&:subtitle_file?) || (vid.type == 'mkv' ? 'maybe' : false)
          { type: 'movie', title: vid.title, year: vid.year.to_i, high_definition: vid.hd?, subtitles: sub }
        when CLI.options.tv?
          vid = files.reject { |f| f.class == self.class }.select(&:video_file?) or return
          sub = files.reject { |f| f.class == self.class }.select(&:subtitle_file?)
          sub = sub.any? ? (sub.count == vid.count ? true : 'partial') : (vid.any?{ |v| v.type == 'mkv' } ? 'maybe' : false)
          hd  = vid.all?(&:hd?) ? true : (vid.any?(&:hd) ? 'partial' : false )
          { type: 'show', title: vid.first.title, season: vid.first.season.to_i, episodes: vid.count, high_definition: hd, subtitles: sub }
      end

      ::File.open("#{path}/.presidium_meta_data", "w") do |f|
        f.write(info.to_yaml)
      end
    end

    private
      def dry_run?
        CLI.options.dry?
      end
  end
end
