module MediaOrganiser
  class CLI
    class << self
      attr_accessor :options
    end

    attr_accessor :dir

    def initialize(directory, options)
      self.class.options = options
      self.dir = Directory.new(directory)
    end

    def run
      if self.class.options.dry?
        puts "WARNING: Dry run. No actual changes will be made."
        puts
      end

      dir.rename_files
    end
  end
end
