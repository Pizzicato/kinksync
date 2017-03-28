module Kinksync
  # Configuration class
  #
  class Configuration
    # absolute path to mounted cloud storage location
    attr_reader :remote_path

    # initializes Configuration with nil value for remote_path
    #
    def initialize
      @remote_path = nil
    end

    # Returns absolute path of remote path
    #
    # @return [String] remote path
    def remote_path=(remote_path)
      @remote_path = File.expand_path(remote_path)
    end
  end
end
