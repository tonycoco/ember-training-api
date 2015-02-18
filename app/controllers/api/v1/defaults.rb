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

          def active_model_serializer_errors!(errors, status)
            status(status)
            errors
          end
        end
      end
    end
  end
end
