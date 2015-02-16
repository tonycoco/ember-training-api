class ContactSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :email,
    :first_name,
    :last_name,
    :phone_number,
    :created_at,
    :updated_at
  )
end
