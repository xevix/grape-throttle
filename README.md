## Overview

The grape-throttle gem provides a simple endpoint-specific throttling mechanism for Grape.

## Requirements

* Grape >= 0.10.0
* Redis

## Usage

### Build and Install

To use, just install the gem from RubyGems or via Bundler by requiring it in your Gemfile.

```
gem 'grape-throttle'
```

### Middleware Setup

Then in your Grape API, install the middleware which will do the throttling. At a minimum, it requires a Redis instance for caching as the `cache` parameter.

**Simple Case**

```ruby
use Grape::Middleware::ThrottleMiddleware, cache: Redis.new
```

In this simple case, you just set up the middleware, and pass it a Redis instance.

**Advanced Case**

```ruby
use Grape::Middleware::ThrottleMiddleware, cache: $redis, user_key: ->(env) do
  # Use the current_user's id as an identifier
  user = current_user
  user.nil? ? nil : user.id
end
```

In this more advanced case, the Redis instance is in the global variable `$redis`.

The `user_key` parameter is a function that can be used to determine a custom identifier for a user. This key is used to form the Redis key to identify this user uniquely. It defaults to the IP address. The `env` parameter given to the function is the Rack environment and can be used to determine information about the caller.

**Logging**

The gem will log errors to STDOUT, if you prefer a different logger you can use the logger option to pass in your own logger.

```ruby
use Grape::Middleware::ThrottleMiddleware, cache: Redis.new, logger: Logger.new('my_custom_log.log')
```

### Endpoint Usage

This gem adds a `throttle` DSL-like method that can be used to throttle different endpoints differently.

The `throttle` method takes a Hash of the period to throttle, and the maximum allowed hits. After the maximum, the middleware throws an error with Grape's `error!` function.

Supported predefined periods are: `:hourly`, `:daily`, `:monthly`.

Example:

```ruby
class API < Grape::API
  resources :users do

    # Allow start of competition only every 10 minutes
    desc "Start competition"
    throttle period: 10.minutes, limit: 1
    params do
      requires :id, type: Integer, desc: "id"
    end
    post "/:id/competition" do
      User.find(params[:id]).start_competition
    end

    # 3 times a day max
    desc "Fetch a user"
    throttle daily: 3
    params do
      requires :id, type: Integer, desc: "id"
    end
    get "/:id" do
      User.find(params[:id])
    end

    # Once a month or the user will go crazy
    desc "Poke a user"
    throttle monthly: 1
    params do
      requires :id, type: Integer, desc: "id"
    end
    post "/:id/poke" do
      User.find(params[:id]).poke
    end

    # No limit to the amount we can annoy users
    desc "Annoy a user"
    params do
      requires :id, type: Integer, desc: "id"
    end
    post "/:id/annoy" do
      User.find(params[:id]).annoy
    end
  end
end
```

## TODO

* Custom error handling and error strings, status etc.
* Allow use of something other than Redis for caching

## Thanks

Thanks to the awesome Grape community, and to @dblock for all the help getting this thing going.
