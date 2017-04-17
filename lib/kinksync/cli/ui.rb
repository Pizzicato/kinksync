module Kinksync
  module CLI
    #
    # CLI functionality to communicate with user
    class UI
      #
      # Ask user for cloud path if not configured
      def self.setup
        retrieve_cloud_path unless Kinksync.configuration.cloud_path
      end

      #
      # Does sync and informs users about it
      def self.do_sync
        display_pre_sync_info
        begin
          Kinksync.sync!(ARGV)
        rescue Error::InvalidSyncPath => e
          invalid_sync_path_error(e.message)
          retry unless ARGV.empty?
        end
        log_synced
        display_post_sync_info
      end

      #
      # Displays error message produced when cloud_path is not valid
      def self.invalid_cloud_path_error
        puts "#{'Error'.light_red}: Invalid cloud path provided."
      end

      #
      # Displays error message produced when config file is not valid
      def self.config_file_error
        puts "#{'Error'.light_red}: Something went wrong. Your configuration " \
        "file seems to be invalid.\n" \
        "Delete or edit manually #{Kinksync::Configuration::CONFIG_FILE} " \
        'to solve any problems and try again.'
      end

      #
      # Asks cloud path from user
      def self.retrieve_cloud_path
        puts 'You haven\'t set your cloud storage location yet. Tell me where '\
        'it is, please:'
        begin
          cloud_path = STDIN.gets.chomp
          Kinksync.configuration.cloud_path = cloud_path
        rescue
          puts 'Not a valid path. Try again or exit (Ctrl-C):'
          retry
        end
      end

      #
      # Displays console messages before sync is done
      def self.display_pre_sync_info
        puts "Using #{Kinksync.configuration.cloud_path} as cloud path."
        if ARGV.empty?
          puts 'Kinksyncing all files in your cloud path...'.light_blue
        else
          puts 'Kinksyncing...'.light_blue
        end
      end

      #
      # Returns error message produced when cloud_path is not valid and exits
      def self.invalid_sync_path_error(path)
        puts "#{'Warning'.light_yellow}: #{path} is not a valid path"
      end

      #
      # Log all files synced
      def self.log_synced
        File.open(Kinksync::Configuration::SYNC_LOG, 'w') do |file|
          Kinksync.synced.each do |f|
            file.puts f.sub(Kinksync.configuration.cloud_path, '')
          end
        end
      end

      #
      # Display information of synced files
      def self.display_post_sync_info
        synced = Kinksync.synced
        puts 'Done!'.light_blue
        if synced.empty?
          puts 'All up to date, nothing synced.'
        else
          puts "#{synced.length} files synced."
          puts "Check #{Kinksync::Configuration::SYNC_LOG}"
        end
      end

      private_class_method :retrieve_cloud_path, :display_pre_sync_info,
                           :invalid_sync_path_error, :log_synced,
                           :display_post_sync_info
    end
  end
end
