module Rails
  module AppEnv
    class Railtie < Rails::Railtie
      initializer :load_helpers, before: :initialize_logger do
        Rails.extend(Helpers)
      end

      initializer :set_credentials, before: :initialize_logger do
        Rails::AppEnv::Credentials.initialize!
      end

      config.after_initialize do
        Rails::Info.property "Application environment", Rails.app_env
      end

      console do |app|
        require_relative "console"

        app.config.console = Rails::AppEnv::Console.new(app)
        puts "Loading #{Rails.app_env} application environment (rails-app_env #{Rails::AppEnv::VERSION})" # standard:disable Rails/Output
      end
    end
  end
end
