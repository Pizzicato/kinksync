module Kinksync
  # Configuration class
  #
  class Configuration
    # Configuration folder location
    CONFIG_DIR = File.expand_path('~/.kinksync').freeze
    # Configuration file location
    CONFIG_FILE = (CONFIG_DIR + '/config.yml').freeze
    # File to save log
    SYNC_LOG = (CONFIG_DIR + '/last_sync.log').freeze

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

    # returns cloud_path value
    def cloud_path
      @config[:cloud_path]
    end

    # Sets absolute path of cloud path
    #
    # @return [String] cloud path
    def cloud_path=(path)
      raise Error::InvalidCloudPath unless File.directory?(path)
      @config[:cloud_path] = File.expand_path(path)
      config_to_file
    end

    private

    def empty_config
      { cloud_path: nil }
    end

    def config_to_file
      FileUtils.mkdir_p(CONFIG_DIR) unless File.directory?(CONFIG_DIR)
      File.open(CONFIG_FILE, 'w') { |file| YAML.dump(@config, file) }
    end

    def config_from_file
      return unless File.exist?(CONFIG_FILE)
      config = YAML.load_file(CONFIG_FILE)
      # Raise error if cloud path from config file is not valid
      unless File.directory?(config[:cloud_path])
        raise Error::InvalidCloudPathFromConfigFile
      end
      config
    end
  end
end
