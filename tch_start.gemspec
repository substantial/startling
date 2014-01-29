# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tch_start/version'

Gem::Specification.new do |spec|
  spec.name          = "tch_start"
  spec.version       = TchStart::VERSION
  spec.authors       = ["Shaun Dern"]
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
end
