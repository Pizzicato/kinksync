require_relative '../spec_helper'

module Kinksync
  describe 'Configuration' do
    describe '#mega_path' do
      it 'has nil as default value' do
        expect(Configuration.new.mega_path).to be_nil
      end
    end

    describe '#mega_path=' do
      it 'can set value' do
        config = Configuration.new
        config.mega_path = '/test/path'
        expect(config.mega_path).to eq('/test/path')
      end
    end
    describe '#mega_path' do
      it 'has nil as default value' do
        expect(Configuration.new.mega_path).to be_nil
      end
    end

    describe '#log_file=' do
      it 'can set value' do
        config = Configuration.new
        config.mega_path = '/test/path/logfile.log'
        expect(config.mega_path).to eq('/test/path/logfile.log')
      end
    end
  end
end
