require 'spec_helper'

module Moltin
  module Resources
    describe Base do
      class MyTestModel < Moltin::Models::Base
        attributes :id, :name
      end

      describe '.attributes' do
        it 'sets the attributes' do
          expect(MyTestModel.attributes_list).to eq([:id, :name, :original_payload,
                                                     :relationships, :flow_fields])
        end
      end

      describe '#initialize' do
        context 'when symbols' do
          it 'sets the attributes' do
            model = MyTestModel.new(id: '1', name: 'Something')
            expect(model.id).to eq '1'
            expect(model.name).to eq 'Something'
            expect(model.original_payload).to eq(id: '1', name: 'Something')
          end
        end

        context 'when strings' do
          it 'sets the attributes' do
            model = MyTestModel.new('id' => '1', 'name' => 'Something')
            expect(model.id).to eq '1'
            expect(model.name).to eq 'Something'
            expect(model.original_payload).to eq('id' => '1', 'name' => 'Something')
          end
        end
      end
    end
  end
end
