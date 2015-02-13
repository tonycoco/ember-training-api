require "rails_helper"

describe ContactSerializer do
  it { is_expected.to have_key(:id) }
  it { is_expected.to have_key(:email) }
  it { is_expected.to have_key(:first_name) }
  it { is_expected.to have_key(:last_name) }
  it { is_expected.to have_key(:phone_number) }
  it { is_expected.to have_key(:created_at) }
  it { is_expected.to have_key(:updated_at) }
end
