module Rails
  module AppEnv
    module Helpers
      def app_env
        return Rails.env if ENV["APP_ENV"].blank?

        @_app_env ||= EnvironmentInquirer.new(ENV["APP_ENV"])
      end
    end
  end
end
