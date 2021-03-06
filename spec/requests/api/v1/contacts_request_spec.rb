require "rails_helper"

describe "API::V1::Contacts Requests" do
  subject { response }

  let(:status) { subject.status }
  let(:body) { subject.body }
  let(:json) { JSON.parse(body).with_indifferent_access }
  let(:contact_json) { json[:contact] }
  let(:error_json) { json[:error] }

  describe "GET /api/v1/contacts" do
    let(:contacts_json) { json[:contacts] }

    context "without items" do
      before do
        get "/api/v1/contacts"
      end

      it { is_expected.to be_ok }
      it { is_expected.to be_success }
      it { expect(status).to eq(200) }
      it { expect(json).to have_key(:contacts) }
      it { expect(contacts_json).to be_empty }
    end

    context "with items" do
      let(:number_of_contacts) { 3 }
      let!(:contacts) { FactoryGirl.create_list :contact, number_of_contacts }
      let(:expected_contacts_json) do
        contacts.map do |contact|
          JSON.parse(ContactSerializer.new(contact).to_json).with_indifferent_access[:contact]
        end
      end

      before do
        get "/api/v1/contacts"
      end

      it { is_expected.to be_ok }
      it { is_expected.to be_success }
      it { expect(status).to eq(200) }
      it { expect(json).to have_key(:contacts) }
      it { expect(contacts_json).to have(number_of_contacts).items }
      it { expect(contacts_json).to match_array(expected_contacts_json) }
    end
  end

  describe "GET /api/v1/contacts/:id" do
    context "not found" do
      before do
        get "/api/v1/contacts/0"
      end

      it { is_expected.to_not be_ok }
      it { is_expected.to_not be_success }
      it { expect(status).to eq(404) }
      it { expect(json).to have_key(:error) }
      it { expect(error_json).to eq("Couldn't find Contact with ID = 0") }
    end

    context "found" do
      let(:contact) { FactoryGirl.create(:contact) }
      let(:expected_contact_json) do
        JSON.parse(ContactSerializer.new(contact).to_json).with_indifferent_access
      end

      before do
        get "/api/v1/contacts/#{contact.id}"
      end

      it { is_expected.to be_ok }
      it { is_expected.to be_success }
      it { expect(status).to eq(200) }
      it { expect(json).to have_key(:contact) }
      it { expect(json).to eq(expected_contact_json) }
    end
  end

  describe "POST /api/v1/contacts" do
    context "invalid" do
      let!(:another_contact) { FactoryGirl.create(:contact) }
      let(:contact_attributes) { FactoryGirl.attributes_for(:contact, email: another_contact.email) }

      before do
        expect do
          post "/api/v1/contacts", contact: contact_attributes
        end.to_not change { Contact.count }
      end

      it { is_expected.to_not be_ok }
      it { is_expected.to_not be_success }
      it { expect(status).to eq(422) }
      it { expect(json).to have_key(:email) }
      it { expect(json[:email]).to match_array(["has already been taken"]) }
    end

    context "valid" do
      let(:contact_attributes) { FactoryGirl.attributes_for(:contact) }
      let(:expected_contact_json) do
        JSON.parse(ContactSerializer.new(Contact.last).to_json).with_indifferent_access[:contact]
      end

      before do
        expect do
          post "/api/v1/contacts", contact: contact_attributes
        end.to change { Contact.count }.from(0).to(1)
      end

      it { is_expected.to_not be_ok }
      it { is_expected.to be_success }
      it { expect(status).to eq(201) }
      it { expect(json).to have_key(:contact) }
      it { expect(contact_json).to eq(expected_contact_json) }
    end
  end

  describe "PUT /api/v1/contacts/:id" do
    let(:unique_email) { Faker::Internet.email }

    context "not found" do
      before do
        put "/api/v1/contacts/0", contact: { email: unique_email }
      end

      it { is_expected.to_not be_ok }
      it { is_expected.to_not be_success }
      it { expect(status).to eq(404) }
      it { expect(json).to have_key(:error) }
      it { expect(error_json).to eq("Couldn't find Contact with ID = 0") }
    end

    context "found" do
      let(:contact) { FactoryGirl.create(:contact) }
      let(:another_contact) { FactoryGirl.create(:contact) }

      context "invalid" do
        before do
          put "/api/v1/contacts/#{contact.id}", contact: { email: another_contact.email }
        end

        it { is_expected.to_not be_ok }
        it { is_expected.to_not be_success }
        it { expect(status).to eq(422) }
        it { expect(json).to have_key(:email) }
        it { expect(json[:email]).to match_array(["has already been taken"]) }
      end

      context "valid" do
        let(:expected_contact_json) do
          expected = JSON.parse(ContactSerializer.new(contact).to_json).with_indifferent_access
          expected[:contact][:email] = unique_email
          expected[:contact].delete(:updated_at)
          expected[:contact]
        end

        before do
          put "/api/v1/contacts/#{contact.id}", contact: { email: unique_email }
        end

        it { is_expected.to be_ok }
        it { is_expected.to be_success }
        it { expect(status).to eq(200) }
        it { expect(json).to have_key(:contact) }
        it { expect(contact_json).to include(expected_contact_json) }
      end
    end
  end

  describe "DELETE /api/v1/contacts/:id" do
    let!(:contact) { FactoryGirl.create(:contact) }

    context "not found" do
      before do
        expect do
          delete "/api/v1/contacts/0"
        end.to_not change { Contact.count }
      end

      it { is_expected.to_not be_ok }
      it { is_expected.to_not be_success }
      it { expect(status).to eq(404) }
      it { expect(json).to have_key(:error) }
      it { expect(error_json).to eq("Couldn't find Contact with ID = 0") }
    end

    context "found" do
      before do
        expect do
          delete "/api/v1/contacts/#{contact.id}"
        end.to change { Contact.count }.from(1).to(0)
      end

      it { is_expected.to_not be_ok }
      it { is_expected.to be_success }
      it { expect(status).to eq(204) }
      it { expect(body).to be_empty }
    end
  end
end
