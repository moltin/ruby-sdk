require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new

begin
  ap '---------------------------'
  ap 'Uploading local file...'
  file1 = moltin.files.create(Moltin.root + '/examples/assets/image.jpg', public: false).data
  ap file1

  ap '---------------------------'
  ap 'Uploading remote file...'
  file2 = moltin.files.create('https://placeholdit.imgix.net/~text?&w=350&h=150', public: false).data
  ap file2

  ap '---------------------------'
  ap 'Cleaning up...'
  moltin.files.delete(file1.id)
  moltin.files.delete(file2.id)
rescue => e
  ap 'Something went wrong.'
  ap e
end
