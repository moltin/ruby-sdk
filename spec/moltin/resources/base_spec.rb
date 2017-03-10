require 'spec_helper'

module Moltin
  module Resources
    describe Base do
      let(:config) { Moltin::Configuration.new }

      describe '#initialize' do
        it 'sets config and storage' do
          storage = { test: '123' }
          resource = described_class.new(config, storage)

          expect(resource.config).to eq config
          expect(resource.storage).to eq storage
        end
      end
    end
  end
end
