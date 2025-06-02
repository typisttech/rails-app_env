module EnvHelpers
  private

  def with_app_env(app_env, &block)
    Rails.instance_variable_set :@_app_env, nil
    switch_env "APP_ENV", app_env, &block
  end

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
