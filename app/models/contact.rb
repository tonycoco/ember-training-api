class Contact < ActiveRecord::Base
  validates :email, uniqueness: true
  validates :email, :first_name, :last_name, :phone_number, presence: true
end
