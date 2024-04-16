require "rails/engine"

module Jets::Rails
  class Engine < Rails::Engine
    # Need to use before_configuration for dotenv
    # so env values can be used in config/initializers
    config.before_configuration do
      Jets.boot # sets up autoloader
    end

    # Let Jets handle these autoload paths
    #
    # Jets.project.config.all_load_paths example:
    #
    #     app/events
    #     app/extensions
    #     shared/resources
    #     shared/extensions
    #     app/functions
    #     shared/functions
    #
    config.before_initialize do
      Jets.project.config.all_load_paths.each do |path|
        Rails.autoloaders.main.ignore(Rails.root.join(path))
      end
    end
  end
end
