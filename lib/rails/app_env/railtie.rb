module Rails
  module AppEnv
    class Railtie < Rails::Railtie
      config.before_configuration do
        Rails.extend(Helpers)
      end

      config.after_initialize do
        Rails::Info.property "Application environment" do
          Rails.app_env
        end
      end
    end
  end
end
