require 'spec_helper'

describe "ThrottleHelper" do
  subject do
    Class.new(Grape::API) do
      use Grape::Middleware::ThrottleMiddleware, cache: Redis.new

      throttle daily: 3
      get('/throttle') do
        "step on it"
      end

      throttle period: 10.minutes, limit: 3
      get('/throttle-custom-period') do
        "step on it"
      end
    end
  end

  def app
    subject
  end

  describe "#throttle" do
    it "is not throttled within the rate limit" do
      3.times { get "/throttle" }
      expect(last_response.status).to eq(200)
    end

    it "is throttled beyond the rate limit" do
      4.times { get "/throttle" }
      expect(last_response.status).to eq(403)
    end

    describe "with custom period" do

      it "is not throttled within the rate limit" do
        3.times { get "/throttle-custom-period" }
        expect(last_response.status).to eq(200)
      end

      it "is throttled beyond the rate limit" do
        4.times { get "/throttle-custom-period" }
        expect(last_response.status).to eq(403)
      end

    end
  end
end
