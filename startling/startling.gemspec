# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'startling/version'

Gem::Specification.new do |spec|
  spec.name          = "startling"
  spec.version       = Startling::VERSION
  spec.authors       = ["Aaron Jensen", "Shaun Dern", "Jeff Forde", "Cassie Koomjian"]
  spec.email         = ["startling@substantial.com"]
  spec.summary       = %q{script for startling a story}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "webmock", "~> 1.20"
  spec.add_development_dependency "excon", "~> 0.45"
  spec.add_development_dependency "dotenv", "~> 2.1"

  spec.add_dependency "octokit", "~> 4.2"
  spec.add_dependency "highline", "~> 1.6"
  spec.add_dependency "paint", "~> 0.9"
  spec.add_dependency "parallel", "~> 1.4"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency 'business_time', '~> 0.7.3'
end
