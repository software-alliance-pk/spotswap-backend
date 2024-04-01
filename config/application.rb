require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# ...

module SpotSwap
  class Application < Rails::Application
<<<<<<< HEAD
    # ...

=======
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # comment added
>>>>>>> f0661b8cf43d4ae4348048f77cd9b235be9a4637
    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = "/cable"

    config.active_storage.replace_on_assign_to_many = false

    # Remove the line below if you don't want to allow credentials for all origins
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: false
      end
    end

    # ...

    config.assets.paths << Rails.root.join('app', 'assets')

    Dotenv::Railtie.load

    Dir.glob("#{Rails.root}/app/assets/images/**/").each do |path|
      config.assets.paths << path
    end

    config.api_only = false
  end
end
