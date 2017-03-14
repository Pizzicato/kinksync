require 'kinksync/version'
require 'kinksync/configuration'

##
# Kynsync parent module for all classes
##
module Kinksync
  class << self
    attr_writer :configuration
  end

  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end
end
