module Rails
  module AppEnv
    module Credentials
      class << self
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
      end
    end
  end
end
