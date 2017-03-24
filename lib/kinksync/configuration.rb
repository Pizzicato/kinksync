module Kinksync
  # Configuration class
  # Attributes
  #    - remote_path: absolute path to mounting cloud storage location
  #    - log_file: path to mounting cloud storage location
  #
  class Configuration
    attr_reader :remote_path

    def initialize
      @remote_path = nil
    end

    def remote_path=(remote_path)
      @remote_path = File.expand_path(remote_path)
    end
  end
end
