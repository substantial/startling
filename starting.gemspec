# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'startling/version'

Gem::Specification.new do |spec|
  spec.name          = "startling"
  spec.version       = Startling::VERSION
  spec.authors       = ["Aaron Jensen", "Shaun Dern", "Jeff Forde"]
  spec.email         = ["tchdevs@substantial.com"]
  spec.description   = %q{script for startling a Tch Story}
  spec.summary       = %q{script for startling a Tch Story}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "webmock", "~> 1.20"
  spec.add_development_dependency "excon"
  spec.add_development_dependency "dotenv"

  spec.add_dependency "octokit", "~> 3.7"
  spec.add_dependency "highline", "~> 1.6"
  spec.add_dependency "paint", "~> 0.9"
  spec.add_dependency "parallel", "~> 1.4"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency 'business_time', '~> 0.7.3'
end
