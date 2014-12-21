module Grape
  module Extensions
    module ThrottleExtension

      def throttle(options={})
        route_setting :throttle, options
        options
      end

      Grape::API.extend self
    end

  end
end
