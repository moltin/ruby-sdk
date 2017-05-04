require 'moltin'

moltin = Moltin::Client.new(client_id: 'FTtrUHsKHstAOtAhN2VjKbpvK08ZXOKZ0GAQaiIAcc',
                            client_secret: 'iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc')

response = moltin.files.create('spec/fixtures/files/desk.jpg')
p response

moltin.files.create('https://s3-eu-west-1.amazonaws.com/files.moltin/e461222e-7780-45d3-8a41-81b45ee6b7c6/c48056b3-cefd-416c-9d1d-1617947923a9')
# id = response.data.id
# expect(id).not_to be_nil
# expect(response.data).to be_kind_of(Moltin::Models::File)
#
# response = moltin.files.delete(response.data.id)
# expect(response.data.id).to eq id

# require 'moltin'
#
# moltin = Moltin::Client.new(client_id: 'FTtrUHsKHstAOtAhN2VjKbpvK08ZXOKZ0GAQaiIAcc',
#                             client_secret: 'iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc')
#
# response = moltin.files.create('https://s3-eu-west-1.amazonaws.com/files.moltin/e461222e-7780-45d3-8a41-81b45ee6b7c6/c48056b3-cefd-416c-9d1d-1617947923a9')
# p response
# id = response.data.id
# expect(id).not_to be_nil
# expect(response.data).to be_kind_of(Moltin::Models::File)
#
# response = moltin.files.delete(response.data.id)
# expect(response.data.id).to eq id
