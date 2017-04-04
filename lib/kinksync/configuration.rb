module Kinksync
  # Configuration class
  #
  class Configuration
    # Configuration folder location
    CONFIG_DIR = File.expand_path('~/.kinksync').freeze
    # Configuration file location
    CONFIG_FILE = (CONFIG_DIR + '/config.yml').freeze

    # Initializes Configuration instance with nil values unless
    # config file was created previously
    #
    def initialize
      @config = config_from_file || empty_config
    end

    # Resets Configuration class, deleting persistent info in CONFIG_FILE
    #
    def self.reset
      FileUtils.rm(CONFIG_FILE) if File.exist?(CONFIG_FILE)
    end

    # Resets configuration instance to initial values
    #
    def reset
      @config = empty_config
    end

    # Checks if configuration is valid (no nil values)
    #
    def valid?
      !@config.value?(nil) && Dir.exist?(@config[:remote_path])
    end

    # returns remote_path value
    def remote_path
      @config[:remote_path]
    end

    # Sets absolute path of remote path
    #
    # @return [String] remote path
    def remote_path=(path)
      path = File.expand_path(path)
      unless File.directory?(path)
        raise Error::InvalidRemotePath, "Not a valid directory: #{path}"
      end
      @config[:remote_path] = path
      config_to_file
    end

    private

    def empty_config
      { remote_path: nil }
    end

    def config_to_file
      FileUtils.mkdir_p(CONFIG_DIR) unless File.directory?(CONFIG_DIR)
      File.open(CONFIG_FILE, 'w') { |file| YAML.dump(@config, file) }
      @config
    end

    def config_from_file
      return unless File.exist?(CONFIG_FILE)
      # Raise error if File not YAML
      f_config = YAML.load_file(CONFIG_FILE)
      (f_config.keys == empty_config.keys) && !f_config.value?(nil) ? f_config : nil
    end
  end
end
