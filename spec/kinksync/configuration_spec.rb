require_relative '../spec_helper'

module Kinksync
  describe 'Configuration' do
    describe '.new' do
      before do
        Configuration.reset
      end
      context "when there isn't a config file" do
        it 'has nil values for all its attributes' do
          expect(Configuration.new.cloud_path).to be_nil
        end
      end
      context 'when there is a config file' do
        it 'gets attribute values from config file' do
          config = Configuration.new
          config.cloud_path = '/test/path'
          config.reset
          expect(config.cloud_path).to be_nil
          expect(Configuration.new.cloud_path).to eq('/test/path')
        end
      end
    end

    describe '.reset' do
      it 'deletes config file' do
        Configuration.new.cloud_path = '/test/path'
        expect(File.exist?(Configuration::CONFIG_FILE)).to be true
        Configuration.reset
        expect(File.exist?(Configuration::CONFIG_FILE)).to be false
      end
    end

    describe '#reset' do
      it 'sets all attribute values to nil' do
        config = Configuration.new
        config.cloud_path = '/test/path'
        config.reset
        expect(config.cloud_path).to be_nil
      end
    end

    describe '#valid?' do
      it 'returns false if any attribute value is nil' do
        expect(Configuration.new.valid?).to be false
      end
      it 'returns false if all attribute values are set' do
        config = Configuration.new
        config.cloud_path = '/test/path'
        expect(config.valid?).to be true
      end
    end

    # #cloud_path method tests covered in .new examples
    describe '#cloud_path=' do
      context 'when path exist' do
        before do
          Configuration.reset
          @config = Configuration.new
          @config.cloud_path = '/test/path'
        end
        it 'can set value' do
          expect(@config.cloud_path).to eq('/test/path')
        end
        it 'saves value to config file' do
          f_config = YAML.load_file(Configuration::CONFIG_FILE)
          expect(f_config[:cloud_path]).to eq('/test/path')
        end
      end
      context "when path doesn't exist" do
        it 'raises error' do
        end
      end
    end
  end
end
