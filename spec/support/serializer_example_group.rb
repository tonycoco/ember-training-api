module SerializerExampleGroup
  extend ActiveSupport::Concern

  included do
    let(:resource_name) { described_class.name.underscore[0..-12].to_sym }
    let(:attributes) { FactoryGirl.attributes_for(resource_name) }

    let(:resource) do
      double(resource_name, attributes).tap do |double|
        allow(double).to receive_message_chain(:read_attribute_for_serialization) { |name| attributes[name] }
      end
    end

    let(:serializer) { described_class.new(resource) }

    subject { serializer.serializable_hash.with_indifferent_access }
  end

  RSpec.configure do |config|
    config.define_derived_metadata(file_path: /spec\/serializers/) do |metadata|
      metadata[:type] ||= :serializer
    end

    config.include self, type: :serializer
  end
end
