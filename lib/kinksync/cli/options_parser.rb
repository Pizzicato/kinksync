module Kinksync
  module CLI
    #
    # CLI parsing commands arguments functionality
    class OptionsParser
      # Options specified on the command line
      attr_reader :options

      def self.parse(args)
        begin
          OptionParser.new do |parser|
            Options.define_options(parser)
            parser.parse!(args)
          end
        rescue OptionParser::InvalidOption
          puts "Error: Invalid option. See 'kinksync --help'"
        rescue OptionParser::MissingArgument
          puts 'Error: Add cloud path location after -c or --cloud_path. ' \
                "See 'kinksync --help'"
        end
      end

      #
      # CLI options -> cloud_path, version and help message
      class Options
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

        private

        def self.banner(parser)
          parser.banner = 'Kinksync can sync files located all over the ' \
          'directory tree in different computers using any ' \
          'cloud storage'
          parser.separator ''
          parser.separator 'Usage: kinksync [OPTION] [PATHS_LIST]'
          parser.separator ''
          parser.separator 'Options:'
        end

        def self.cloud_path_option(parser)
          parser.on('-c',
                    '--cloud_path CLOUD_PATH',
                    'Set cloud path mount point location. If ' \
                    "it's already defined, it will " \
                    'be changed.') do |c|
                      Kinksync.configuration.cloud_path = c
                    end

        end
      end
    end
  end
end
