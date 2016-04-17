# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'socialkit/version'

Gem::Specification.new do |spec|
  spec.name          = "socialkit"
  spec.version       = Socialkit::VERSION
  spec.authors       = ["Anis Tayebali"]
  spec.email         = ["anis.tayebali@72andsunny.com"]
  spec.summary       = %q{ Real Time Social Feed }
  spec.description   = %q{ Listens to social services, filters data and then publishes out to pusher.}
  spec.homepage      = ""
  spec.license       = "72andsunny"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["socialkit"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "3.2"
  spec.add_development_dependency "pry", '0.10.1'

  spec.add_runtime_dependency 'pusher', "0.14.4"
  spec.add_runtime_dependency 'twitter', "5.14.0"
  spec.add_runtime_dependency 'lmdb', '0.4.8'
  spec.add_runtime_dependency 'cld', '0.7.0'

end
