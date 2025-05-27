module Rails
  module AppEnv
    class EnvironmentInquirer < ActiveSupport::EnvironmentInquirer
      # Optimization for the two extra Heroku pipeline stages, so this inquirer doesn't need to rely on
      # the slower delegation through method_missing that StringInquirer would normally entail.
      DEFAULT_ENVIRONMENTS = %w[staging review]

      def initialize(env)
        super

        DEFAULT_ENVIRONMENTS.each do |default|
          instance_variable_set :"@#{default}", env == default
        end
      end

      DEFAULT_ENVIRONMENTS.each do |env|
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{env}?
            @#{env}
          end
        RUBY
      end
    end
  end
end
