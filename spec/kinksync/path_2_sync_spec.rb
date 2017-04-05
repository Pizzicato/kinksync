require_relative '../spec_helper'

module Kinksync
  describe 'Path2Sync' do
    describe '#initialize' do
      it 'raises exception if path argument not provided' do
        expect { Path2Sync.new }.to raise_error(ArgumentError)
      end
      it 'raises exception if path provided not String' do
        expect { Path2Sync.new(4) }.to raise_error(TypeError)
      end
      it 'does not raise errors if String path provided' do
        expect { Path2Sync.new('test') }.not_to raise_error
      end
    end

    describe '#sync' do
      before do
        Kinksync.configure { |config| config.cloud_path = '~/remote/path/' }
        @multi_dir, @one_dir = create_directory_tree('~/subdir')
      end
      context 'when path does not have subdirectories' do
        it 'copies all files to twin path' do
          Path2Sync.new(@one_dir).sync
          local = Find.find(@one_dir)
          remote = Find.find(Kinksync.configuration.cloud_path + @one_dir)
          expect(equal_directories_content?(local, remote)).to be true
        end
      end
      context 'when path has subdirectories' do
        it 'copies all files to twin path' do
          Path2Sync.new(@multi_dir).sync
          local = Find.find(@multi_dir)
          remote = Find.find(Kinksync.configuration.cloud_path + @multi_dir)
          expect(equal_directories_content?(local, remote)).to be true
        end
      end
    end
  end
end
