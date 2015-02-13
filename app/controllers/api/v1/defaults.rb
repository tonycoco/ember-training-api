module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api/v1"
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        helpers do
          def logger
            Rails.logger
          end

          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |exception|
          error_response(message: exception.message, status: 404)
        end

        rescue_from :all do |exception|
          error_response(message: "Something went wrong", status: 500)
        end
      end
    end
  end
end
