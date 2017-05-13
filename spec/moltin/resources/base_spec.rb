require 'spec_helper'

module Moltin
  module Resources
    describe Base do
      let(:config) { Moltin::Configuration.new }

      describe '#initialize' do
        it 'sets config and storage' do
          storage = { test: '123' }
          config.storage = storage
          resource = described_class.new(config)

          expect(resource.config).to eq config
          expect(resource.storage).to eq storage
        end
      end
    end
  end
end
