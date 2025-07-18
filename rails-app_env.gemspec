require_relative "lib/rails/app_env/version"

Gem::Specification.new do |spec|
  spec.name = "rails-app_env"
  spec.version = Rails::AppEnv::VERSION
  spec.authors = ["Typist Tech Limited", "Tang Rufus"]
  spec.email = ["opensource+swagger_ui_standalone@typist.tech", "tangrufus@gmail.com"]

  spec.summary = "Rails APP_ENV is like RAILS_ENV but for configurations only."
  spec.homepage = "https://github.com/typisttech/rails-app_env"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["funding_uri"] = "https://github.com/sponsors/tangrufus"

  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  rails_version = ">= 8.0.0"
  spec.add_dependency "railties", rails_version
  spec.add_dependency "activesupport", rails_version
end
