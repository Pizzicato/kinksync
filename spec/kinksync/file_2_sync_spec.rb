require 'fakefs/spec_helpers'

require_relative '../spec_helper'

module Kinksync
  describe 'File2Sync' do
    describe '#initialize' do
      before do
        Kinksync.configure { |config| config.remote_path = 'remote/path/' }
      end

      it 'raises exception if file argument not provided' do
        expect { File2Sync.new }.to raise_error(ArgumentError)
      end
      it 'raises exception if file provided not String' do
        expect { File2Sync.new(4) }.to raise_error(TypeError)
      end
      it 'does not raise errors if String path provided' do
        expect { File2Sync.new('test') }.not_to raise_error
      end
    end

    describe '#sync' do
      include FakeFS::SpecHelpers
      before do
        Kinksync.configure { |config| config.remote_path = '~/remote/path/' }
        @dir = File.expand_path('~/subdir')
        @twin_dir = Kinksync.configuration.remote_path + @dir
        @file = @dir + '/test_file.test'
        @twin_file = @twin_dir + '/test_file.test'
        FileUtils.mkdir_p(@dir)
        file_handle = File.new(@file, 'w')
        file_handle.puts('TEST DATA')
        file_handle.close
      end
      context 'when one file exists' do
        before do
          File2Sync.new(@file).sync
        end
        it 'creates directory tree in twin destination' do
          expect(File.directory?(@twin_dir)).to be true
        end
        it 'creates the file in twin destination' do
          expect(File.exist?(@twin_file)).to be true
        end
        it 'copies the file contents in twin destination' do
          expect(FileUtils.compare_file(@file, @twin_file)).to be true
        end
      end
      context 'when both files exist' do
        before do
          @twin_file_contents = 'NEWER TEST DATA'
          FileUtils.mkdir_p(@twin_dir)
          # Wait so timestamps are different for each file
          sleep(1)
          file_handle = File.new(@twin_file, 'w')
          file_handle.puts(@twin_file_contents)
          file_handle.close
        end
        it 'copies newer file over older' do
          expect(FileUtils.compare_file(@file, @twin_file)).to be false
          expect(FileUtils.uptodate?(@twin_file, [@file])).to be true
          File2Sync.new(@file).sync
          expect(FileUtils.compare_file(@file, @twin_file)).to be true
          file_handle = File.new(@twin_file, 'r')
          expect(file_handle.gets.chomp).to eq(@twin_file_contents)
          file_handle.close
        end
      end
    end
  end
end
