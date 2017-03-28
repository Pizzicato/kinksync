# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kinksync/version'

Gem::Specification.new do |spec|
  spec.name          = 'kinksync'
  spec.version       = Kinksync::VERSION
  spec.authors       = ['Pablo']
  spec.email         = ['pabloguaza@gmail.com']

  spec.summary       = 'Sync files all over directory tree with any cloud storage mounted on your file system'
  spec.homepage      = 'https://github.com/Pizzicato/kinksync'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'bin'
  spec.executables << 'kinksync'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'fakefs', '~> 0.10'
end
