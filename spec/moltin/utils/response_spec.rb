require 'spec_helper'

module Moltin
  module Utils
    describe Response do
      let(:params) { {} }
      let(:response) { Moltin::Utils::Response.new(Moltin::Models::Product, params) }

      describe '#errors' do
        let(:params) { { body: { 'errors' => { 'message' => 'Bad Request' } } } }

        it 'returns the errors hash' do
          expect(response.errors).to eq('message' => 'Bad Request')
        end
      end

      describe '#data' do
        context 'array' do
          let(:params) { { body: { 'data' => [{ 'id' => '1' }] } } }

          it 'returns an array' do
            expect(response.data).to be_kind_of(Array)
          end

          it 'maps each element to the given class' do
            expect(response.data.first).to be_kind_of(Moltin::Models::Product)
          end
        end

        context 'single resource' do
          let(:params) { { body: { 'data' => { 'id' => '1' } } } }

          it 'returns an instance of the given class' do
            expect(response.data).to be_kind_of(Moltin::Models::Product)
          end
        end
      end

      describe '#links' do
        let(:params) { { body: { 'links' => { 'some' => 'link' } } } }

        it 'returns the link hash' do
          expect(response.links).to eq('some' => 'link')
        end
      end

      describe '#included' do
        let(:params) { { body: { 'included' => { 'some' => 'included' } } } }

        it 'returns the included hash' do
          expect(response.included).to eq('some' => 'included')
        end
      end

      describe '#meta' do
        let(:params) { { body: { 'meta' => { 'some' => 'meta' } } } }

        it 'returns the meta hash' do
          expect(response.meta).to eq('some' => 'meta')
        end
      end
    end
  end
end
