require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new

begin
  ap '---------------------------'
  ap 'Creating a webhook integration...'
  integration = moltin.integrations.create(name: 'My Integration',
                                           enabled: true,
                                           integration_type: 'webhook',
                                           observes: ['file.created'],
                                           configuration: {
                                             url: 'http://example.com',
                                             secret: 'opensesame'
                                           }).data
  ap integration

  ap '---------------------------'
  ap 'Disabling integration...'
  integration = moltin.integrations.update(integration.id, name: 'My Integration',
                                                           integration_type: 'webhook',
                                                           enabled: false,
                                                           observes: ['file.created'],
                                                           configuration: {
                                                             url: 'http://example.com',
                                                             secret: 'opensesame'
                                                           })
  ap integration

  ap '---------------------------'
  ap 'Retrieve all integrations...'
  ap moltin.integrations.all.data

  ap '---------------------------'
  ap 'Cleaning up...'
  moltin.integrations.all.each do |integration|
    moltin.integrations.delete(integration.id)
  end
rescue => e
  ap 'Something went wrong.'
  ap e
  moltin.integrations.all.each do |integration|
    moltin.integrations.delete(integration.id)
  end
end
