require 'grape'
require 'grape/extensions/throttle_extension'
require 'logger'

module Grape
  module Middleware
    autoload :ThrottleMiddleware,   'grape/middleware/throttle_middleware'
  end
end
