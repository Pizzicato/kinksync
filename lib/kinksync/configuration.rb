module Kinksync
  class Configuration
    attr_accessor :mega_path, :log_file

    def initialize
      @mega_path = nil
      @log_file = nil
    end
  end
end
