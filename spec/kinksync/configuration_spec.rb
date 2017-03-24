require_relative '../spec_helper'

module Kinksync
  describe 'Configuration' do
    describe '#remote_path' do
      it 'has nil as default value' do
        expect(Configuration.new.remote_path).to be_nil
      end
    end

    describe '#remote_path=' do
      it 'can set value' do
        config = Configuration.new
        config.remote_path = '/test/path'
        expect(config.remote_path).to eq('/test/path')
      end
    end
  end
end
