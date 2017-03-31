# Kinksync

Kinksync is a simple gem that let's you synchronize files all over your directory tree with any cloud storage mounted on your file system. If you have two similar systems in different computers and want to share certain configuration files, Kinksync will help you do it easily.

## Installation

Install it from RubyGems:

```
$ gem install kinksync
```

Kinksync was made to be used as a CLI, but you can also include in your application's Gemfile:

```ruby
gem 'kinksync'
```

And then execute:
```
    $ bundle
```

## Usage

Simple run it from your terminal.
```
$ kinksync [OPTION] [PATHS_LIST]
```

### Without arguments
Sync all files under remote cloud path with local storage

### Optional arguments
* `-h, --help` Show this help message and exit
* `-v, --version` Show version and exit
* `[FILE_OR_PATHS_LIST]` Sync all files inside each path, or the file itself

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/Pizzicato/kinksync>.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
