module API
  module V1
    class Contacts < Grape::API
      include API::V1::Defaults

      resource :contacts do
        desc "Return all contacts"
        get do
          Contact.all
        end

        desc "Return a contact"
        params do
          requires :id, type: Integer, desc: "ID"
        end
        route_param :id do
          get do
            Contact.where(id: permitted_params[:id]).first!
          end
        end

        desc "Create a contact"
        params do
          requires :first_name, type: String, desc: "First Name"
          requires :last_name, type: String, desc: "Last Name"
          requires :email, type: String, desc: "Email"
          requires :phone_number, type: String, desc: "Phone Number"
        end
        post do
          Contact.create!(permitted_params)
        end

        desc "Update a contact"
        params do
          requires :id, type: Integer, desc: "ID"
          optional :first_name, type: String, desc: "First Name"
          optional :last_name, type: String, desc: "Last Name"
          optional :email, type: String, desc: "Email"
          optional :phone_number, type: String, desc: "Phone Number"
        end
        route_param :id do
          patch do
            contact = Contact.where(id: permitted_params[:id]).first!
            contact.update(permitted_params)
            contact
          end
        end

        desc "Delete a contact"
        params do
          requires :id, type: Integer, desc: "ID"
        end
        route_param :id do
          delete do
            body false

            contact = Contact.where(id: permitted_params[:id]).first!
            contact.destroy
          end
        end
      end
    end
  end
end
