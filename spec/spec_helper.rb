require 'bundler/setup'
require 'kinksync'
require 'fakefs/spec_helpers'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include FakeFS::SpecHelpers
end

def random_string(n_chars = 8)
  ('a'..'z').to_a.shuffle[0, n_chars].join
end

def create_files(location, n_files)
  (1..n_files).each do
    file_handle = File.new("#{location}/#{random_string}", 'w')
    file_handle.puts(random_string(150))
    file_handle.close
  end
end

def create_directory_tree(base_dir)
  base_dir = File.expand_path(base_dir)
  one_dir = "#{base_dir}/onedir"
  multi_dir = "#{base_dir}/multidir"

  FileUtils.mkdir_p(one_dir)
  (1..3).each { |i| FileUtils.mkdir_p("#{multi_dir}/#{i}") }

  Find.find(base_dir) do |f|
    create_files(f, 3) if File.directory?(f)
  end
  [base_dir, one_dir, multi_dir]
end

def equal_directories_content?(local, remote)
  local.sort == remote.map { |e| e.sub(Kinksync.configuration.cloud_path, '') }.sort
end

def twin_path(path)
  if remote? path
    path.sub(Kinksync.configuration.cloud_path, '')
  else
    Kinksync.configuration.cloud_path + path
  end
end

def remote?(path)
  File.dirname(path).start_with?(Kinksync.configuration.cloud_path)
end
