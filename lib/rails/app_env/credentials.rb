require_relative "error"

module Rails
  module AppEnv
    module Credentials
      class AlreadyInitializedError < Rails::AppEnv::Error; end

      class << self
        attr_reader :original

        def initialize!
          raise AlreadyInitializedError.new "Rails::AppEnv::Credentials has already been initialized." if @initialized
          @initialized = true

          @original = Rails.application.config.credentials
          Rails.application.config.credentials = configuration

          monkey_patch_rails_credentials_command!
        end

        def configuration
          ActiveSupport::InheritableOptions.new(
            content_path: content_path,
            key_path: key_path
          )
        end

        private

        def content_path
          path = Rails.root.join("config/credentials/#{Rails.app_env}.yml.enc")
          path = Rails.root.join("config/credentials.yml.enc") unless path.exist?
          path
        end

        def key_path
          path = Rails.root.join("config/credentials/#{Rails.app_env}.key")
          path = Rails.root.join("config/master.key") unless path.exist?
          path
        end

        def monkey_patch_rails_credentials_command!
          require_relative "../rails_ext/credentials_command"
        end
      end
    end
  end
end
