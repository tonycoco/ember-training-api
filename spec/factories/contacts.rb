FactoryGirl.define do
  factory :contact do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::Base.numerify("(###) ###-####") }
  end
end
