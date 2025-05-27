require_relative "helpers"

module Rails
  module AppEnv
    class Railtie < ::Rails::Railtie
      config.before_configuration do
        ::Rails.extend(Helpers)
      end
    end
  end
end
