require_relative "boot"

require "rails/all"
begin
  if defined?(ActionMailer) && defined?(ActionMailer::Base)
    ActionMailer::Base.singleton_class.class_eval do
      unless method_defined?(:preview_path=)
        define_method(:preview_path=) do |path|
          self.preview_paths = Array(path)
        end
      end

      unless method_defined?(:preview_path)
        define_method(:preview_path) do
          Array(self.preview_paths).first
        end
      end
    end
  end
rescue => e
  warn "action_mailer_preview_compat early shim failed: #{e.class}: #{e.message}"
end


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Project3
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_dispatch.default_headers = {
      "X-Content-Type-Options" => "nosniff",
      "X-XSS-Protection" => "0",
      "X-Download-Options" => "noopen",
      "X-Permitted-Cross-Domain-Policies" => "none",
      "Referrer-Policy" => "strict-origin-when-cross-origin"
    }

    if ENV["FRAME_ANCESTORS"] && !ENV["FRAME_ANCESTORS"].empty?
      config.action_dispatch.default_headers["Content-Security-Policy"] =
        "frame-ancestors #{ENV['FRAME_ANCESTORS']};"
    end
  end
end
