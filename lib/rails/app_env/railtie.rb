module Rails
  module AppEnv
    class Railtie < Rails::Railtie
      config.before_configuration do
        Rails.extend(RailsHelpers)
        Rails.application.extend(ApplicationHelpers)
      end

      config.before_configuration do
        # TODO: Allow opt-out.
        Rails::AppEnv::Credentials.initialize!
      end

      config.after_initialize do
        Rails::Info.property "Application environment" do
          Rails.app_env
        end
      end

      console do |app|
        # TODO: Allow opt-out.
        require_relative "console"
        app.config.console = Rails::AppEnv::Console.new(app)

        puts "Loading #{Rails.app_env} application environment (rails-app_env #{Rails::AppEnv::VERSION})" # standard:disable Rails/Output
      end
    end
  end
end
