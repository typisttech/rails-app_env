# frozen_string_literal: true

require "rails"

module EnvHelpers
  private

  DEFAULT_RAILS_ENV = "development"

  def with_rails_env(env, &block)
    Rails.instance_variable_set :@_env, nil
    switch_env "RAILS_ENV", env do
      switch_env "RACK_ENV", nil, &block
    end
  end

  def switch_env(key, value)
    old, ENV[key] = ENV[key], value
    yield
  ensure
    ENV[key] = old
  end
end
