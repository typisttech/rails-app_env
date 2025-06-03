module Rails::AppEnv::Extensions
  module OriginalAware
    private

    def config
      Rails::AppEnv::Credentials.original
    end
  end
end
