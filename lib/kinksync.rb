require 'find'

require 'kinksync/version'
require 'kinksync/configuration'
require 'kinksync/path_2_sync'
require 'kinksync/file_2_sync'

##
# Kynsync parent module for all classes.
# Provides methods for configuration and synchronization of a group of files
# and/or directories
##
module Kinksync
  class << self
    # Configuration class instance
    attr_writer :configuration
  end

  # Configures a Kynksync module with the values provided through the block
  # it recieves
  #
  # @param [block]
  #    Values:
  #      - remote_path: path to mounting cloud storage location
  #
  # @example
  #   Kinksync.configure do |config|
  #     config.remote_path = '/home/pablo/MEGA/kinksync/'
  #     config.log_file = config.remote_path + 'kinksync.log'
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
    @configuration = nil
  end

  # Syncs lists of files and paths recieved as arguments. If no arg is provided
  # syncs all files in remote path
  #
  # @param paths_to_sync [Array] List of files and paths to sync
  #
  # @example
  #   Kinksync.sync([
  #     'a_file.mp3',
  #     '/an/absolute/path/',
  #     'another_file.avi',
  #     'a/relative/path'
  #   ])
  #
  def self.sync(paths_to_sync = [])
    synced = []
    paths_to_sync = [Kinksync.configuration.remote_path] if paths_to_sync.empty?
    paths_to_sync.each { |p| synced += Path2Sync.new(p).sync }
    synced
  end
end
