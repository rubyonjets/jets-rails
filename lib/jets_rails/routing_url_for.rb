# Cannot easily append module to modify the url_helpers.  Rails includes the
# url helpers in an anonymous proxy module and class.
# Rails source: http://bit.ly/2Sb4SCy
#
# The code is in actionpack/lib/action_dispatch/routing/route_set.rb
# and looks something like this.
#
#   def url_helpers(supports_path = true)
#     ...
#     Module.new do
#       proxy_class = Class.new do
#         include UrlFor
#         include routes.named_routes.path_helpers_module
#         include routes.named_routes.url_helpers_module
#
# Since we cannot monkeypatch by appending we'll open up ActionView::RoutingUrlFor
# directly.  Would like to do this in a better way since this copying and pasting
# hack is pretty brittle.

require "action_view"

module ActionView
  module RoutingUrlFor
    include JetsRails::StageName

    def url_for(options = nil)
      url = case options
      when String
        options
      when nil
        super(only_path: _generate_paths_by_default)
      when Hash
        options = options.symbolize_keys
        unless options.key?(:only_path)
          options[:only_path] = only_path?(options[:host])
        end

        super(options)
      when ActionController::Parameters
        unless options.key?(:only_path)
          options[:only_path] = only_path?(options[:host])
        end

        super(options)
      when :back
        _back_url
      when Array
        components = options.dup
        if _generate_paths_by_default
          polymorphic_path(components, components.extract_options!)
        else
          polymorphic_url(components, components.extract_options!)
        end
      else
        method = _generate_paths_by_default ? :path : :url
        builder = ActionDispatch::Routing::PolymorphicRoutes::HelperMethodBuilder.send(method)

        case options
        when Symbol
          builder.handle_string_call(self, options)
        when Class
          builder.handle_class_call(self, options)
        else
          builder.handle_model_call(self, options)
        end
      end
      add_stage_name(url)
    end
  end
end
