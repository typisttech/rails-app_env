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
    end
  end
end
