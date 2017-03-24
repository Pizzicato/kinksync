module Kinksync
  #
  # Class that represents a duple of files with *absolute* path which
  # can be synced
  #
  class File2Sync
    #
    # Configures a File2Sync class
    # @param file [String] local or remote file to sync
    #
    def initialize(file)
      @file = file
      @twin_file = twin_file(file)
    end

    #
    # Sync a file, copying origin over destination
    #
    def sync
      origin, destination = prepare_for_sync
      FileUtils.cp(origin, destination)
    end

    private

    #
    # Gets twin file of file provided
    # @param file [String] file to get twin from
    #
    def twin_file(file)
      if remote? file
        file.sub(Kinksync.configuration.remote_path, '')
      else
        Kinksync.configuration.remote_path + file
      end
    end

    #
    # Decides whether a file is remote or local
    # @param file [String]
    #
    def remote?(file)
      File.dirname(file).start_with?(Kinksync.configuration.remote_path)
    end

    #
    # Decides which file will be origin or destination and makes destination
    # directory tree if needed
    # @return origin, destination [Array of Strings]
    #
    def prepare_for_sync
      if File.exist?(@twin_file)
        if newer?(@twin_file)
          [@twin_file, @file]
        else
          [@file, @twin_file]
        end
      else
        FileUtils.mkdir_p(File.dirname(@twin_file))
        [@file, @twin_file]
      end
    end

    #
    # Decides whether a file is newer or older than its twin_file
    # @param file [String]
    #
    def newer?(file)
      FileUtils.uptodate?(file, [twin_file(file)])
    end
  end
end
