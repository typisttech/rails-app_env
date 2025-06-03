require_relative "app_env/version"
require_relative "app_env/railtie"

module Rails
  module AppEnv
    autoload :ApplicationHelpers, "rails/app_env/application_helpers"
    autoload :Console, "rails/app_env/console"
    autoload :Credentials, "rails/app_env/credentials"
    autoload :EnvironmentInquirer, "rails/app_env/environment_inquirer"
    autoload :Error, "rails/app_env/error"
    autoload :RailsHelpers, "rails/app_env/rails_helpers"
  end
end
