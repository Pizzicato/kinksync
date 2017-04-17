module Kinksync
  module CLI
    #
    # CLI parsing commands arguments functionality
    class OptionsParser
      # Options specified on the command line
      attr_reader :options

      #
      # Parses options of kinksync command using OptionParser
      #
      # @param args [Array of Strings] ARGV
      def self.parse!(args)
        OptionParser.new { |opts| Options.define_options(opts).parse!(args) }
      rescue OptionParser::InvalidOption
        puts "#{'Error'.light_red}: Invalid option. Run kinksync --help"
        exit 1
      rescue OptionParser::MissingArgument
        puts "#{'Error'.light_red}: Add cloud path location after " \
                    '-c or --cloud_path. Run kinksync --help'
        exit 1
      end

      #
      # CLI options defining functionality usinng OptionParser
      class Options
        #
        # Defines options for kinksync command
        #
        # @param parser [OptionParser]
        def self.define_options(parser)
          banner(parser)
          cloud_path_option(parser)
          parser.on('-h', '--help', 'Show this message') do
            puts parser
            exit
          end
          parser.on('-v', '--version', 'Show version') do
            puts Kinksync::VERSION
            exit
          end
        end

        #
        # Defines banner for kinksync command
        #
        # @param parser [OptionParser]
        def self.banner(parser)
          parser.banner = 'Kinksync can sync files located all over the ' \
          'directory tree in different computers using any ' \
          'cloud storage'
          parser.separator ''
          parser.separator 'Usage: kinksync [OPTION] [PATHS_LIST]'
          parser.separator ''
          parser.separator 'Options:'
        end

        #
        # Defines cloud_path option for kinksync command
        #
        # @param parser [OptionParser]
        def self.cloud_path_option(parser)
          parser.on('-c', '--cloud_path CLOUD_PATH',
                    'Set cloud path mount point location. If ' \
                    "it's already defined, it will be changed") do |cloud_path|
            Kinksync.configure { |config| config.cloud_path = cloud_path }
          end
        end

        private_class_method :banner, :cloud_path_option
      end
    end
  end
end
