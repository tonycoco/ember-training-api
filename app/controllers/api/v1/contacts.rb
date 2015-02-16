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
            begin
              Contact.where(id: permitted_params[:id]).first!
            rescue ActiveRecord::RecordNotFound
              error!("Couldn't find Contact with ID = #{permitted_params[:id]}", 404)
            end
          end
        end

        desc "Create a contact"
        params do
          requires :email, type: String, desc: "Email"
          requires :first_name, type: String, desc: "First Name"
          requires :last_name, type: String, desc: "Last Name"
          requires :phone_number, type: String, desc: "Phone Number"
        end
        post do
          begin
            Contact.create!(permitted_params)
          rescue ActiveRecord::RecordInvalid => exception
            error!(exception.record.errors, 400)
          end
        end

        desc "Update a contact"
        params do
          requires :id, type: Integer, desc: "ID"
          optional :email, type: String, desc: "Email"
          optional :first_name, type: String, desc: "First Name"
          optional :last_name, type: String, desc: "Last Name"
          optional :phone_number, type: String, desc: "Phone Number"
        end
        route_param :id do
          patch do
            begin
              contact = Contact.where(id: permitted_params[:id]).first!
              contact.update!(permitted_params)
              contact
            rescue ActiveRecord::RecordNotFound
              error!("Couldn't find Contact with ID = #{permitted_params[:id]}", 404)
            rescue ActiveRecord::RecordInvalid => exception
              error!(exception.record.errors, 422)
            end
          end
        end

        desc "Delete a contact"
        params do
          requires :id, type: Integer, desc: "ID"
        end
        route_param :id do
          delete do
            begin
              body false

              contact = Contact.where(id: permitted_params[:id]).first!
              contact.destroy
            rescue ActiveRecord::RecordNotFound
              error!("Couldn't find Contact with ID = #{permitted_params[:id]}", 404)
            end
          end
        end
      end
    end
  end
end
