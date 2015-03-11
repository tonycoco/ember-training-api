module API
  module V1
    class Ping < Grape::API
      include API::V1::Defaults

      get :ping do
        { hello: "Testing 1. 2. 3." }
      end
    end
  end
end
