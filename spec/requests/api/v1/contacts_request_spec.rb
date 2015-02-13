require "rails_helper"

describe "API::V1::Contacts Requests" do
  subject { response }

  let(:status) { subject.status }
  let(:body) { subject.body }
  let(:json) { JSON.parse(body).with_indifferent_access }

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
          JSON.parse(ContactSerializer.new(contact).to_json)["contact"]
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
    let(:contact) { FactoryGirl.create(:contact) }

    context "not found" do
      before do
        get "/api/v1/contacts/0"
      end

      it { is_expected.to_not be_ok }
      it { is_expected.to_not be_success }
      it { expect(status).to eq(404) }
    end

    context "found" do
      let(:expected_contact_json) do
        JSON.parse(ContactSerializer.new(contact).to_json)
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
    it "needs specs"
  end

  describe "PATCH /api/v1/contacts/:id" do
    it "needs specs"
  end

  describe "DELETE /api/v1/contacts/:id" do
    let(:contact) { FactoryGirl.create(:contact) }

    context "not found" do
      let(:expected_error_json) do
        JSON.parse({
          error: "Couldn't find Contact with [WHERE \"contacts\".\"id\" = ?]"
        }.to_json)
      end

      before do
        delete "/api/v1/contacts/0"
      end

      it { is_expected.to_not be_ok }
      it { is_expected.to_not be_success }
      it { expect(status).to eq(404) }
      it { expect(json).to have_key(:error) }
      it { expect(json).to eq(expected_error_json) }
    end

    context "found" do
      before do
        delete "/api/v1/contacts/#{contact.id}"
      end

      it { is_expected.to_not be_ok }
      it { is_expected.to be_success }
      it { expect(status).to eq(204) }
      it { expect(body).to be_empty }
    end
  end
end
