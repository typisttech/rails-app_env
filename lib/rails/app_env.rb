require_relative "app_env/version"

require_relative "app_env/error"

require_relative "app_env/console"
require_relative "app_env/credentials"
require_relative "app_env/environment_inquirer"

require_relative "app_env/extensions/rails/app_env_aware"
require_relative "app_env/extensions/credentials_command/original_aware"
require_relative "app_env/extensions/application/app_configurable"

require_relative "app_env/railtie"

module Rails
  module AppEnv
  end
end
