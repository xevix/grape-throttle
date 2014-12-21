Gem::Specification.new do |s|
  s.name        = 'grape-throttle'
  s.version     = '0.0.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Alejandro Wainzinger']
  s.email       = ['alejandro.wainzinger@gmail.com']
  s.homepage    = 'https://github.com/xevix/grape-throttle'
  s.summary     = %q{A middleware for Grape to add endpoint-specific throttling.}
  s.description = %q{A middleware for Grape to add endpoint-specific throttling.}
  s.license     = 'MIT'

  s.add_development_dependency 'grape', '= 0.10.0'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'fakeredis', '~> 0.3.0'

  s.add_runtime_dependency 'redis'

  s.files = ["lib/grape-throttle.rb", "lib/grape/extensions/throttle_extension.rb", "lib/grape/middleware/throttle_middleware.rb"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end
