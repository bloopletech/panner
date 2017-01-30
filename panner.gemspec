# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'panner/version'

Gem::Specification.new do |spec|
  spec.name          = "panner"
  spec.version       = Panner::VERSION
  spec.authors       = ["Brenton \"B-Train\" Fletcher"]
  spec.email         = ["i@bloople.net"]

  spec.summary       = %q{Panner pans for website gold.}
  spec.description   = %q{Panner pans for website gold.}
  spec.homepage      = "http://panner.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "mechanize"
  spec.add_dependency "deba", "~> 0.6"
end
