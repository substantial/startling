# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teaching_channel_start/version'

Gem::Specification.new do |spec|
  spec.name          = "teaching-channel-start"
  spec.version       = TeachingChannelStart::VERSION
  spec.authors       = ["Aaron Jensen", "Shaun Dern"]
  spec.email         = ["shaun@substantial.com"]
  spec.description   = %q{script for starting a Tch Story}
  spec.summary       = %q{script for starting a Tch Story}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock", "~>1.15.0"
  spec.add_development_dependency "excon", ">=0.27.5"
  spec.add_development_dependency "dotenv"

  spec.add_dependency "octokit", "~> 2.0"
  spec.add_dependency "highline", "~> 1.6"
  spec.add_dependency "colored", "~> 1.2"
  spec.add_dependency "parallel", "~> 0.9"
  spec.add_dependency "faraday", "~> 0.8.0"
  spec.add_dependency "business_time", "~> 0.7.0"
end
