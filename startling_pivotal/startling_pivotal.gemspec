# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'startling_pivotal/version'

Gem::Specification.new do |spec|
  spec.name          = "startling-pivotal"
  spec.version       = StartlingPivotal::VERSION
  spec.authors       = ["Jeff Forde"]
  spec.email         = ["tchdevs@substantial.com"]
  spec.description   = %q{Startling Pivotal Api}
  spec.summary       = %q{Startling Pivotal Api}
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
  spec.add_development_dependency "webmock", "~> 1.20"
  spec.add_development_dependency "excon"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_dependency "faraday", "~> 0.9"
end
