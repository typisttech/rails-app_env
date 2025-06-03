module Rails
  module Command
    class CredentialsCommand
      private

      def config
        Rails::AppEnv::Credentials.original
      end
    end
  end
end
