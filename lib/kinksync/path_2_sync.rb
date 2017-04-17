module Kinksync
  #
  # Class that represents an *absolute* local or cloud path which
  # contains file(s) and/or directories to sync
  #
  class Path2Sync
    #
    # Configures a Path2Sync class
    #
    # @param path [String] local or cloud path to sync
    #
    def initialize(path)
      path = File.expand_path(path)
      raise Error::InvalidSyncPath, path unless File.exist?(path)
      @path = path
      @files_to_sync = Find.find(@path).select do |f|
        File.file?(f) && !File.symlink?(f)
      end
    end

    #
    # Syncs all files in path and its subdirectories, ignores symlinks
    def sync
      synced = []
      @files_to_sync.each { |f| synced.push(f) if File2Sync.new(f).sync }
      synced
    end
  end
end
