require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new(logger: Logger.new(STDOUT))

begin
  ap '---------------------------'
  ap 'Create the base product...'
  base = moltin.products.create(name: 'iPad Mini 4',
                                slug: 'ipad-mini-4',
                                sku: 'mini-4',
                                manage_stock: true,
                                status: 'live',
                                commodity_type: 'physical',
                                description: 'Learn, play, surf, create.',
                                price: [
                                  {
                                    currency: 'GBP',
                                    includes_tax: true,
                                    amount: '41900'
                                  }
                                ],
                                'stock' => 1000)
  ap base

  variations = {
    Colour: {
      silver: {
        name: 'Silver',
        name_append: ' Silver',
        sku_append: '.SLVR',
        slug_append: '-silver',
        description: 'Silver iPad'
      },
      gold: {
        name: 'Gold',
        name_append: ' Gold',
        sku_append: '.GLD',
        slug_append: '-gold',
        description: 'Gold iPad'
      },
      grey: {
        name: 'Space Grey',
        name_append: ' Space Grey',
        sku_append: '.SPGCRY',
        slug_append: '-space-grey',
        description: 'Space Grey iPad'
      }
    },
    Storage: {
      medium: {
        name: '128GB',
        name_append: ' 128GB',
        sku_append: '.128GB',
        slug_append: '-128',
        description: '128GB Storage'
      }
    },
    Connectivity: {
      wifi: {
        name: 'Wifi',
        name_append: ' Wifi',
        sku_append: '.WIFI',
        slug_append: '-wifi',
        description: 'Wifi only connectivity'
      },
      wifiAndCellular: {
        name: 'Wifi',
        name_append: ' Wifi + Cellular',
        sku_append: '.WIFI.CELLULAR',
        slug_append: '-wifi-cellular',
        description: 'Wifi & Cellular connectivity'
      }
    }
  }

  ap '---------------------------'
  ap 'Creating variations...'
  variations.each do |name, variation|
    ap "Creating #{name}..."
    saved_variation = moltin.variations.create(name: name).data

    variation.each do |_key, value|
      ap "Creating option #{value[:name]}..."

      updated_variation = saved_variation.variation_options.create(name: value[:name],
                                                                   description: value[:description]).data
      option = updated_variation.options.first

      ap "Creating modifier #{value[:name_append]}..."
      option.product_modifiers.create(modifier_type: 'name_append',
                                      value: value[:name_append]).data

      ap "Creating modifier #{value[:sku_append]}..."
      option.product_modifiers.create(modifier_type: 'sku_append',
                                      value: value[:sku_append]).data

      ap "Creating modifier #{value[:slug_append]}..."
      option.product_modifiers.create(modifier_type: 'slug_append',
                                      value: value[:slug_append]).data
    end

    ap 'Creating relation between product and variation...'
    ap moltin.products.create_relationships(base.id, 'variations', saved_variation.id)
  end

  ap '---------------------------'
  ap 'Final product...'
  product = moltin.products.get(base.id).build.data
  ap product

  ap 'Variations...'
  ap moltin.variations.all.data

  ap '---------------------------'
  ap 'Cleaning up...'
  moltin.products.delete(base.id)
  moltin.variations.all.each do |variation|
    moltin.variations.delete(variation.id)
  end
rescue => e
  ap 'Something went wrong.'
  ap e
  moltin.variations.all.each do |variation|
    moltin.variations.delete(variation.id)
  end
end
