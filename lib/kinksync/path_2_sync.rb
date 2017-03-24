module Kinksync
  #
  # Class that represents an *absolute* local or remote path which
  # contains file(s) and/or directories to sync
  #
  class Path2Sync
    #
    # Configures a Path2Sync class
    # @param path [String] local or remote path to sync
    #
    def initialize(path)
      @path = File.expand_path(path)
    end

    #
    # Syncs all files in path and its subdirectories, ignores symlinks
    #
    def sync
      files_to_sync = Find.find(@path).select do |f|
        File.file?(f) && !File.symlink?(f)
      end
      files_to_sync.each { |f| File2Sync.new(f).sync }
    end
  end
end
