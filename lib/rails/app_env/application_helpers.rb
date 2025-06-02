module Rails
  module AppEnv
    module ApplicationHelpers
      def app_config_for(name)
        config_for(name, env: Rails.app_env)
      end
    end
  end
end
