# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'startling_trello/version'

Gem::Specification.new do |spec|
  spec.name          = "startling_trello"
  spec.version       = StartlingTrello::VERSION
  spec.authors       = ["Cassie Koomjian"]
  spec.email         = ["cassie@substantial.com"]

  spec.summary       = %q{Startling Trello integration}
  spec.homepage      = "https://github.com/substantial/startling"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "startling", "~> 0.0.9"
end
