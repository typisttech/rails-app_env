module Rails::AppEnv::Extensions
  module AppConfigurable
    extend self

    def app_config_for(name)
      Rails.application.config_for(name, env: Rails.app_env)
    end
  end
end
