module Lograge
  module Formatters
    class Clean
      def call(data)
        data_clone = data.clone
        clean(data_clone) + meta(data_clone)
      end

      def clean(data)
        "[#{data[:status]}] #{data[:method]} #{data[:path]} (#{data[:controller]}##{data[:action]}) "
      end

      def meta(data)
        "#{data.slice(:format, :duration, :view, :db)}"
      end
    end
  end
end

# If you're using Rails 5's API-only mode and inherit from ActionController::API,
# define configuration as the controller base class which lograge will patch
PrivatirApi::Application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = "ActionController::API"
  config.lograge.formatter = Lograge::Formatters::Clean.new
end
