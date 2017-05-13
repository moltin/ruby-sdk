require 'spec_helper'

module Moltin
  module Resources
    describe Categories do
      let(:config) { Configuration.new }

      describe '#uri' do
        it 'returns the expected uri' do
          category = Moltin::Resources::Categories.new(config, {})
          expect(category.send(:uri)).to eq 'v2/categories'
        end
      end

      describe '#all' do
        it 'receives the list of categories' do
          VCR.use_cassette('resources/categories/all') do
            resource = Moltin::Resources::Categories.new(config, {})
            response = resource.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Category)
            expect(response.response_links).not_to be_nil
            expect(response.included).to be_kind_of Moltin::Models::Included
            expect(response.response_meta).not_to be_nil

            expect(response.data.length).to eq 28
          end
        end

        context 'pagination' do
          context 'limit & offset' do
            it 'limits the number of results and set the offset' do
              VCR.use_cassette('resources/categories/all/limit-offset') do
                resource = Moltin::Resources::Categories.new(config, {})
                response = resource.all.limit(10).offset(10)
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/categories?page[limit]=10&page[offset]=10'
                )
                expect(response.data.length).to eq 10
              end
            end
          end

          context 'limit' do
            it 'limits the number of results returned by the API' do
              VCR.use_cassette('resources/categories/all/limit') do
                resource = Moltin::Resources::Categories.new(config, {})
                response = resource.all.limit(10)
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/categories?page[limit]=10&page[offset]=0'
                )
                expect(response.data.length).to eq 10
              end
            end
          end

          context 'offset' do
            it 'offsets the returned results' do
              VCR.use_cassette('resources/categories/all/offset') do
                resource = Moltin::Resources::Categories.new(config, {})
                response = resource.all.offset(10)
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/categories?page[limit]=100&page[offset]=10'
                )
                expect(response.data.length).to eq 18
              end
            end
          end
        end

        context 'sorting' do
          context 'ASC' do
            it 'sorts the results based on the passed attribute in ascending sort' do
              VCR.use_cassette('resources/categories/all/sort/asc') do
                resource = Moltin::Resources::Categories.new(config, {})
                response = resource.all.sort('name')
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/categories?page[limit]=100&page[offset]=0&sort=name'
                )
              end
            end
          end

          context 'DESC' do
            it 'sorts the results based on the passed attribute in descending sort' do
              VCR.use_cassette('resources/categories/all/sort/desc') do
                resource = Moltin::Resources::Categories.new(config, {})
                response = resource.all.sort('-name')
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/categories?page[limit]=100&page[offset]=0&sort=-name'
                )
              end
            end
          end
        end

        context 'with' do
          it 'includes the specified resources' do
            VCR.use_cassette('resources/categories/all/includes') do
              resource = Moltin::Resources::Categories.new(config, {})
              response = resource.all.with(:parent, :children)
              expect(response.response_links['current']).to eq(
                'https://api.moltin.com/v2/categories?page[limit]=100&page[offset]=0&include=parent,children'
              )
            end
          end
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes' do
          VCR.use_cassette('resources/categories/attributes') do
            resource = Moltin::Resources::Categories.new(config, {})
            response = resource.attributes

            expect(response.data.map(&:label)).to eq(
              %w(Type Id Name Slug Status Description)
            )
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#get' do
        it 'receives the given category', freeze_time: true do
          VCR.use_cassette('resources/categories/get') do
            resource = Moltin::Resources::Categories.new(config, {})
            category = resource.all.data.first
            response = resource.get(category.id)

            expect(response.data.id).to eq category.id
            expect(response.data).to be_kind_of(Moltin::Models::Category)
          end
        end
      end

      describe '#create' do
        context 'valid category' do
          it 'creates a new category', freeze_time: true do
            VCR.use_cassette('resources/categories/create/valid') do
              resource = Moltin::Resources::Categories.new(config, {})
              response = resource.create(name: 'My Category',
                                         slug: 'my-category1',
                                         description: 'Super Category',
                                         status: 'live')

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::Category)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid category' do
          it 'receives the list of errors' do
            VCR.use_cassette('resources/categories/create/invalid') do
              resource = Moltin::Resources::Categories.new(config, {})
              response = resource.create(slug: 'my-category1',
                                         description: 'Super Category',
                                         status: 'live')

              expect(response.errors).to eq(
                [{ 'title' => 'Failed Validation', 'detail' => 'The data.name field is required.' }]
              )
            end
          end
        end
      end

      describe '#update' do
        context 'valid category' do
          it 'updates a new category', freeze_time: true do
            VCR.use_cassette('resources/categories/update/valid') do
              resource = Moltin::Resources::Categories.new(config, {})
              response = resource.create(name: 'My Category',
                                         slug: 'my-category-update-valid',
                                         description: 'Super Category',
                                         status: 'live')

              id = response.data.id
              response = resource.update(id, name: 'My New Category')

              expect(response.data.name).to eq 'My New Category'
              expect(response.data).to be_kind_of(Moltin::Models::Category)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid category' do
          it 'receives the list of errors', freeze_time: true do
            VCR.use_cassette('resources/categories/update/invalid') do
              resource = Moltin::Resources::Categories.new(config, {})
              response = resource.create(name: 'My Category',
                                         slug: 'my-category-update-invalid-1',
                                         description: 'Super Category',
                                         status: 'live')

              id = response.data.id
              response = resource.update(id, name: '')

              expect(response.errors).to eq(
                [{ 'title' => 'Failed Validation', 'detail' => 'The data.name field is required.' }]
              )

              response = resource.delete(id)
              expect(response.data.id).to eq id
            end
          end
        end
      end

      describe '#delete' do
        it 'deletes the category', freeze_time: true do
          VCR.use_cassette('resources/categories/delete') do
            resource = Moltin::Resources::Categories.new(config, {})
            response = resource.create(name: 'My Category',
                                       slug: 'my-category-update-valid',
                                       description: 'Super Category',
                                       status: 'live')

            id = response.data.id
            response = resource.delete(id)
            expect(response.data.id).to eq id

            response = resource.get(id)
            expect(response.errors).to eq([{
                                            'status' => 404,
                                            'detail' => 'The requested category could not be found',
                                            'title' => 'Category not found'
                                          }])
          end
        end
      end

      describe '#tree' do
        it 'loads the tree of categories' do
          VCR.use_cassette('resources/categories/tree') do
            resource = Moltin::Resources::Categories.new(config, {})
            response = resource.tree
            expect(response.data.length).to eq 27
          end
        end
      end

      describe 'relationships' do
        let(:storage) { {} }
        let(:categories) { Moltin::Resources::Categories.new(config, storage) }
        let(:categories_list) { categories.all.data }
        let(:category) { categories_list[0] }
        let(:category_2) { categories_list[1] }
        let(:category_3) { categories_list[2] }

        def clear_relationship(ids, relationship = :categories)
          categories.delete_relationships(category.id, relationship, ids)
          response = categories.get(category.id)

          if ids.respond_to?(:each)
            expect(response.data.map(&:id)).to include(*ids)
          else
            expect(response.data.id).to eq(category.id)
          end
        end

        def check_relationships(ids)
          updated_product = categories.get(category.id).data
          expect(updated_product.relationships['categories']['data']).to eq([*ids].map do |id|
            {
              'type' => 'category',
              'id' => id
            }
          end)
        end

        describe '#create_relationships' do
          context 'relationship found' do
            context 'children' do
              it 'creates the relationship', freeze_time: true do
                VCR.use_cassette('resources/categories/relationships/create/children') do
                  categories.create_relationships(category.id, :children, category_2.id)
                  response = categories.get(category.id)
                  expect(response.data.relationships['children']['data'][0]['id']).to eq(category_2.id)
                  clear_relationship(category_2.id, :children)
                end
              end

              it 'updates the relationship', freeze_time: true do
                VCR.use_cassette('resources/categories/relationships/update/children') do
                  categories.create_relationships(category.id, :children, category_2.id)
                  categories.update_relationships(category.id, :children, category_3.id)
                  response = categories.get(category.id)
                  expect(response.data.relationships['children']['data'].length).to eq(1)
                  expect(response.data.relationships['children']['data'][0]['id']).to eq(category_3.id)
                  clear_relationship(category_3.id, :children)
                end
              end

              it 'deletes the relationship', freeze_time: true do
                VCR.use_cassette('resources/categories/relationships/delete/children') do
                  categories.create_relationships(category.id, :children, category_2.id)
                  response = categories.get(category.id)
                  expect(response.data.relationships['children']['data'].length).to eq(1)
                  categories.delete_relationships(category.id, :children, category_2.id)
                  response = categories.get(category.id)
                  expect(response.data.relationships['children']).to be_nil
                end
              end
            end

            context 'parent' do
              it 'creates the relationship', freeze_time: true do
                VCR.use_cassette('resources/categories/relationships/create/parent') do
                  categories.delete_relationships(category.id, :parent, category_2.id)
                  categories.create_relationships(category.id, :parent, category_2.id)
                  response = categories.get(category.id)
                  expect(response.data.relationships['parent']['data'][0]['id']).to eq(category_2.id)
                  clear_relationship(category_2.id, :parent)
                end
              end

              # TODO
              it 'updates the relationship', freeze_time: true

              # TODO
              it 'deletes the relationship', freeze_time: true
            end
          end

          context 'with invalid relationship' do
            it 'raises an error' do
              VCR.use_cassette('resources/categories/relationships/create/invalid') do
                expect do
                  categories.create_relationships(category.id, :fake, '123')
                end.to raise_error(Moltin::Errors::InvalidRelationshipError)
              end
            end
          end
        end
      end
    end
  end
end
