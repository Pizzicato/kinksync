require 'spec_helper'

describe Kinksync, '#configuration' do
  describe '#configuration' do
    context 'when not initialized' do
      before do
        Kinksync.reset
      end
      it 'returns nil cloud path' do
        expect(Kinksync.configuration.cloud_path).to be_nil
      end
    end

    context 'when initialized' do
      before do
        @cloud_path = 'cloud/path/'

        Kinksync.configure do |config|
          config.cloud_path = @cloud_path
        end
      end

      it 'returns given absolute cloud path' do
        expect(Kinksync.configuration.cloud_path).to eq(File.expand_path(@cloud_path))
      end
    end
  end
  describe '#sync' do
    before do
      Kinksync.configure { |config| config.cloud_path = '~/cloud/path/' }
      path = Kinksync.configuration.cloud_path + '/subdir'
      @base_dir, @one_dir, @multi_dir = create_directory_tree(path)
    end
    context 'when no file or directories provided' do
      it 'syncs all cloud path contents to local' do
        Kinksync.sync
        local = Find.find(twin_path(@base_dir))
        cloud = Find.find(@base_dir)
        expect(equal_directories_content?(local, cloud)).to be true
      end
    end
    context 'when a list of files and directories are provided' do
      it 'syncs each file and directory' do
        list_of_files = Find.find(@one_dir).select { |f| File.file? f }
        list_of_files.push(@multi_dir)
        Kinksync.sync(list_of_files)
        local = Find.find(twin_path(@one_dir), twin_path(@multi_dir))
        cloud = Find.find(@one_dir, @multi_dir)
        expect(equal_directories_content?(local, cloud)).to be true
      end
    end
  end
end
