require 'find'
require 'yaml'
require 'optparse'
require 'colorize'

require 'kinksync/version'
require 'kinksync/configuration'
require 'kinksync/path_2_sync'
require 'kinksync/file_2_sync'
require 'kinksync/errors/configuration'
require 'kinksync/errors/path_2_sync'
require 'kinksync/cli'
require 'kinksync/cli/options_parser'
require 'kinksync/cli/ui'

##
# Kynsync parent module for all classes.
# Provides methods for configuration and synchronization of a group of files
# and/or directories
##
module Kinksync
  class << self
    # Configuration class instance
    attr_writer :configuration
    attr_reader :synced
  end

  @synced = []

  # Configures a Kynksync module with the values provided through the block
  # it recieves
  #
  # @param [block]
  #    Values:
  #      - cloud_path: path to mounting cloud storage location
  #
  # @example
  #   Kinksync.configure do |config|
  #     config.cloud_path = '/home/pablo/MEGA/kinksync/'
  #   end
  #
  def self.configure
    yield(configuration)
  end

  # Returns current configuration or initializes an empty one and returns it
  #
  # @return Configuration object
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Resets configuration: all attributes are set to nil
  #
  # @return Empty Configuration object
  def self.reset
    @configuration.reset
  end

  # Syncs lists of files and paths recieved as arguments. By default it
  # syncs all files in remote path.
  #
  # Removes each element of the paths array once synced
  #
  # @param paths [Array of Strings] List of files and paths to sync
  #
  # @example
  #   Kinksync.sync([
  #     'a_file.mp3',
  #     '/an/absolute/path/',
  #     'another_file.avi',
  #     'a/relative/path'
  #   ])
  #
  def self.sync!(paths = [])
    paths = paths.empty? ? [configuration.cloud_path] : paths
    paths.each do |p|
      paths.shift
      @synced += Path2Sync.new(p).sync
    end
  end
end
