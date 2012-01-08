module MediaOrganiser
  class File
    attr_accessor :name, :path, :pdir, :type

    AUDIO_EXT    = %w(aac ape flac mp3 m4a ogg)
    SUBTITLE_EXT = %w(ass idx srt ssa sub)
    VIDEO_EXT    = %w(avi mkv mov mp4 wmv)

    def initialize(path)
      self.path = path
      self.pdir = ::File.basename(::File.dirname(path))
      self.name = ::File.basename(path)
      self.type = ::File.extname(path).gsub('.', '')
    end

    def rename
      if valid_extensions.include?(type) && !sample_file?
        puts "  RN  '#{name}' => '#{new_name}'"
        ::File.rename(path, path.sub(name, new_name)) unless dry_run?
      else
        unless name == '.DS_Store'
          puts "  DEL '#{name}'"
          ::File.unlink(path) unless dry_run?
        end
      end
    end

    def new_name
      t = case
        when tv?    then [title, "S#{season}E#{episode}"]
        when movie? then [title, cd, year]
      end

      t << resolution if hd?
      t << type

      t.compact.join('.')
    end

    def method_missing(method, *args, &block)
      if m = method.to_s.match(/(video|audio|subtitle)_file\?$/)
        eval "#{m[1].upcase}_EXT.include?(type)"
      else
        super
      end
    end

    def title
      Data.get_title(name)
    end

    def cd
      Data.get_cd(name)
    end

    def year
      Data.get_year(name, true) || Data.get_year(pdir)
    end

    def season
      Data.get_season(name)
    end

    def episode
      Data.get_episode(name)
    end

    def resolution
      Data.get_resolution(name)
    end

    def hd?
      !!resolution
    end

    private
      def dry_run?
        CLI.options.dry?
      end

      def tv?
        CLI.options.tv?
      end

      def movie?
        CLI.options.movie?
      end

      def sample_file?
        !!(name =~ /sample/i)
      end

      def valid_extensions
        AUDIO_EXT + SUBTITLE_EXT + VIDEO_EXT
      end
  end
end
