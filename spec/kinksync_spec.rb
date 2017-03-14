require 'spec_helper'

describe Kinksync, '#configuration' do
  shared_examples 'nil attributes' do
    it 'returns nil mega path' do
      expect(Kinksync.configuration.mega_path).to be_nil
    end
    it 'returns nil log file name' do
      expect(Kinksync.configuration.log_file).to be_nil
    end
  end

  context 'when not initialized' do
    include_examples 'nil attributes'
  end

  context 'when initialized' do
    before do
      @mega_path = 'mega/path/'
      @log_file = @mega_path + 'kinksync.log'

      Kinksync.configure do |config|
        config.mega_path = @mega_path
        config.log_file = @log_file
      end
    end

    it 'returns given mega path' do
      expect(Kinksync.configuration.mega_path).to eq(@mega_path)
    end
    it 'returns given log file name' do
      expect(Kinksync.configuration.log_file).to eq(@log_file)
    end
  end

  context 'when resetted' do
    before do
      Kinksync.reset
    end

    include_examples 'nil attributes'
  end
end
