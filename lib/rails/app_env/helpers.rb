module Rails
  module AppEnv
    module Helpers
      def app_env
        return Rails.env unless ENV["APP_ENV"].present?

        @_app_env ||= EnvironmentInquirer.new(ENV["APP_ENV"])
      end
    end
  end
end
