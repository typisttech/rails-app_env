module Rails
  module AppEnv
    module RailsHelpers
      def app_env
        @_app_env ||= EnvironmentInquirer.new(ENV["APP_ENV"] || Rails.env)
      end
    end
  end
end
