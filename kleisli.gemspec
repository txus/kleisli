# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kleisli/version'

Gem::Specification.new do |spec|
  spec.name          = "kleisli"
  spec.version       = Kleisli::VERSION
  spec.authors       = ["Josep M. Bach", "Ryan Levick"]
  spec.email         = ["josep.m.bach@gmail.com", "ryan.levick@gmail.com"]
  spec.summary       = %q{Usable, idiomatic common monads in Ruby}
  spec.description   = %q{Usable, idiomatic common monads in Ruby}
  spec.homepage      = "https://github.com/txus/kleisli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
