require 'moltin/api/crud_resource'
require 'moltin/resource'

class Moltin::Resource::Mocker < Moltin::Api::CrudResource
  attributes :id, :name, :price
end

describe Moltin::Api::CrudResource do

  describe "#method_missing" do
    context "with valid string attribute" do
      it do
        resource = Moltin::Resource::Mocker.new 'id' => '123'
        expect(resource.id).to eq '123'
      end
    end
    context "with valid symbol attribute" do
      it do
        resource = Moltin::Resource::Mocker.new id: '123'
        expect(resource.id).to eq '123'
      end
    end
    context "with invalid attribute" do
      it do
        resource = Moltin::Resource::Mocker.new 'id' => '123'
        expect {
          resource.random_key
        }.to raise_error
      end
    end
  end

  describe "#respond_to?" do
    context "with valid attribute" do
      it do
        resource = Moltin::Resource::Mocker.new 'id' => '123'
        expect(resource.respond_to? 'id').to eq true
      end
    end
    context "with valid symbol attribute" do
      it do
        resource = Moltin::Resource::Mocker.new 'id' => '123'
        expect(resource.respond_to? 'id').to eq true
      end
    end
    context "with invalid attribute" do
      it do
        resource = Moltin::Resource::Mocker.new 'id' => '123'
        expect(resource.respond_to? 'random_key').to eq false
      end
    end
  end

  describe "#set_attribute" do
    context "using string key" do
      it do
        resource = Moltin::Resource::Mocker.new 'id' => '123'
        resource.send(:set_attribute, 'id', '456')
        expect(resource.id).to eq '456'
      end
    end
    context "using symbol key" do
      it do
        resource = Moltin::Resource::Mocker.new 'id' => '123'
        resource.send(:set_attribute, :id, '456')
        expect(resource.id).to eq '456'
      end
    end
  end

  describe "#get_attribute" do
    context "attribute exists" do
      context "using string lookup" do
        it do
          resource = Moltin::Resource::Mocker.new 'id' => '123'
          expect(resource.send(:get_attribute, 'id')).to eq '123'
        end
      end
      context "using symbol lookup" do
        it do
          resource = Moltin::Resource::Mocker.new id: '123'
          expect(resource.send(:get_attribute, :id)).to eq '123'
        end
      end
      context "contains hash data" do
        it do
          resource = Moltin::Resource::Mocker.new price: { 'value' => '£100' }
          expect(resource.send(:get_attribute, :price)).to eq '£100'
        end
      end
    end
    context "attribute does not exist" do
      it do
        resource = Moltin::Resource::Mocker.new id: '123'
        expect(resource.send(:get_attribute, :random_key)).to eq nil
      end
    end
  end

  describe "#resource_name" do
    it do
      expect(Moltin::Resource::Mocker.resource_name).to eq 'mocker'
    end
  end

  describe "#resource_namespace" do
    it do
      expect(Moltin::Resource::Mocker.resource_namespace).to eq 'mockers'
    end
  end

end
