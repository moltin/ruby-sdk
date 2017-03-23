require 'spec_helper'

module Moltin
  module Utils
    describe Criteria do
      let(:uri) { 'http://example.com' }
      let(:config) { Configuration.new }
      let(:products) { Moltin::Resources::Products.new(config, {}) }
      let(:criteria) { Moltin::Utils::Criteria.new(products, uri) }

      describe '#all' do
        it 'returns self' do
          expect(criteria.all).to eq(criteria)
        end
      end

      describe '#limit' do
        it 'returns self' do
          expect(criteria.limit(10)).to eq(criteria)
        end

        it 'sets the "page[limit]" value' do
          expect(criteria.limit(10).criteria['page[limit]']).to eq(10)
        end
      end

      describe '#offset' do
        it 'returns self' do
          expect(criteria.offset(10)).to eq(criteria)
        end

        it 'sets the "page[offset]" value' do
          expect(criteria.offset(10).criteria['page[offset]']).to eq(10)
        end
      end

      describe '#sort' do
        it 'returns self' do
          expect(criteria.sort('name')).to eq(criteria)
        end

        it 'sets the "sort" value' do
          expect(criteria.sort('name').criteria['sort']).to eq('name')
        end
      end

      describe '#filter' do
        let(:filter) { criteria.filter(eq: { name: 'something' }) }
        it 'returns self' do
          expect(filter).to eq(criteria)
        end

        it 'sets the "filter" value' do
          expect(filter.criteria['filter']).to eq({eq: { name: 'something' }})
        end
      end

      describe '#with' do
        let(:with) { criteria.with(['brands']) }
        it 'returns self' do
          expect(with).to eq(criteria)
        end

        it 'sets the "with" value' do
          expect(with.criteria['include']).to eq(['brands'])
        end
      end

      describe '#formatted_critera' do
        let(:with) { criteria.with(['brands']) }

        it 'returns the expected values' do
          criteria.limit(50).offset(10).sort('name').with(['brands']).filter({
            eq: { name: 'something', sku: '123' },
            has: { description: ['succulent', 'houseplant'] }
          })
          formatted = criteria.send(:formatted_criteria)
          expect(formatted).to eq({
            'page[limit]' => 50,
            'page[offset]' => 10,
            'sort' => 'name',
            'filter' => 'eq(name,something):eq(sku,123):has(description,(succulent,houseplant))',
            'include' => ['brands']
          })
        end
      end

      describe '#[]' do

      end

    end
  end
end
