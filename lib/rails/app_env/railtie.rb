module Rails
  module AppEnv
    class Railtie < Rails::Railtie
      config.before_configuration do
        Rails.extend(Helpers)
      end

      config.before_configuration do |app|
        app.config.credentials.content_path = Rails::AppEnv::Credentials.content_path
        app.config.credentials.key_path = Rails::AppEnv::Credentials.key_path
      end

      config.after_initialize do
        Rails::Info.property "Application environment" do
          Rails.app_env
        end
      end

      console do |app|
        require_relative "console"

        app.config.console = Rails::AppEnv::Console.new(app)
        puts "Loading #{Rails.app_env} application environment (rails-app_env #{Rails::AppEnv::VERSION})" # standard:disable Rails/Output
      end
    end
  end
end
