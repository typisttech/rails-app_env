module Rails
  module Command
    class CredentialsCommand
      def config
        Rails::AppEnv::Credentials.original
      end
    end
  end
end
