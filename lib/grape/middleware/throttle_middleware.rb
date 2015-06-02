module Grape
  module Middleware
    class ThrottleMiddleware < Grape::Middleware::Base
      def before
        endpoint = env['api.endpoint']
        return unless throttle_options = endpoint.route_setting(:throttle)

        if limit = throttle_options[:hourly]
          period = 1.hour
        elsif limit = throttle_options[:daily]
          period = 1.day
        elsif limit = throttle_options[:monthly]
          period = 1.month
        elsif period = throttle_options[:period]
          limit = throttle_options[:limit]
        end
        if limit.nil? || period.nil?
          raise ArgumentError.new('Please set a period and limit (see documentation)')
        end

        user_key = options[:user_key]
        user_value = nil
        user_value = user_key.call(env) unless user_key.nil?
        user_value ||= "ip:#{env['REMOTE_ADDR']}"

        r = endpoint.routes.first
        rate_key = "#{r.route_method}:#{r.route_path}:#{user_value}"

        redis = options[:cache]
        begin
          redis.ping
          current = redis.get(rate_key).to_i
          if !current.nil? && current >= limit
            endpoint.error!("too many requests, please try again later", 403)
          else
            redis.multi do
              redis.incr(rate_key)
              redis.expire(rate_key, period.to_i)
            end
          end

        rescue Exception => e
          logger = Logger.new(STDOUT)
          logger.warn(e.message)
        end

      end

    end
  end
end
