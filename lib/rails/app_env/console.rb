require "rails/commands/console/irb_console"

module Rails
  module AppEnv
    class Console < Rails::Console::IRBConsole
      def colorized_env
        return super if Rails.env == Rails.app_env
        super + ":" + colorized_app_env
      end

      private

      def colorized_app_env
        case Rails.app_env
        when "development"
          IRB::Color.colorize("dev", [:MAGENTA])
        when "production"
          IRB::Color.colorize("prod", [:RED])
        else
          IRB::Color.colorize(Rails.app_env, [:MAGENTA])
        end
      end
    end
  end
end
