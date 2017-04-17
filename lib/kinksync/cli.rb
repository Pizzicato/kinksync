module Kinksync
  ##
  # Kynsync CLI parent module for all CLI classes.
  ##
  module CLI
    #
    # Run Kinksync CLI
    def self.run
      # parse command arguments
      OptionsParser.parse!(ARGV)
      # get Kinksync setup info form user, then sync
      UI.setup
      UI.do_sync
    rescue Error::InvalidCloudPath
      UI.invalid_cloud_path_error
    rescue Psych::SyntaxError, Error::InvalidCloudPathFromConfigFile
      UI.config_file_error
    end
  end
end
