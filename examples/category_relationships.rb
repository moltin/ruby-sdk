require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new

begin
  random_string = SecureRandom.hex

  ap '---------------------------'
  ap 'Creating a new category...'
  cat1 = moltin.categories.create(name: 'My First Category',
                                  slug: "my-first-category-#{random_string}").data
  ap cat1

  ap '---------------------------'
  ap 'Creating a second category...'
  cat2 = moltin.categories.create(name: 'My Second Category',
                                  slug: "my-second-category-#{random_string}").data
  ap cat2

  ap '---------------------------'
  ap 'Creating a third category...'
  cat3 = moltin.categories.create(name: 'My Third Category',
                                  slug: "my-third-category-#{random_string}").data
  ap cat3

  ap '---------------------------'
  ap 'Current Category Tree'
  ap moltin.categories.tree.data

  ap '---------------------------'
  ap 'Make the second category a child of the first one...'
  response = moltin.categories.create_relationships(cat1.id, 'children', cat2.id)
  ap response

  ap '---------------------------'
  ap 'New Category Tree'
  ap moltin.categories.tree.data

  ap '---------------------------'
  ap 'Make the second category a child of the third one instead...'
  response = moltin.categories.create_relationships(cat2.id, 'parent', cat3.id)
  ap response

  ap '---------------------------'
  ap 'New Category Tree'
  ap moltin.categories.tree.data

  ap '---------------------------'
  ap 'Make the second category a child of the first one again...'
  response = moltin.categories.create_relationships(cat2.id, 'parent', cat1.id)
  ap response

  ap '---------------------------'
  ap 'New Category Tree'
  ap moltin.categories.tree.data

  ap '---------------------------'
  ap 'Make the third category the parent of the first one...'
  response = moltin.categories.create_relationships(cat3.id, 'children', cat1.id)
  ap response

  ap '---------------------------'
  ap 'New Category Tree'
  tree = moltin.categories.tree.data
  ap tree

  ap '---------------------------'
  ap 'Remove children of third category...'
  response = moltin.categories.update_relationships(cat3.id, 'children', [])
  ap response

  ap '---------------------------'
  ap 'New Category Tree'
  tree = moltin.categories.tree.data
  ap tree

  ap '---------------------------'
  ap 'Cleaning Up...'
  moltin.categories.all.each do |category|
    moltin.categories.delete(category.id)
  end

  ap 'Test categories have been deleted.'
  ap moltin.categories.tree.data
rescue => e
  ap 'Something went wrong.'
  ap e

  moltin.categories.all.each do |category|
    moltin.categories.delete(category.id)
  end
end
