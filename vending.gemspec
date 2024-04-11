# frozen_string_literal: true

require_relative "lib/vending/version"

Gem::Specification.new do |spec|
  spec.name = "vending"
  spec.version = Vending::VERSION
  spec.authors = ["Fedor Lukyanov"]
  spec.email = ["sleekybadger@gmail.com"]

  spec.summary = "Vending machine"
  spec.homepage = "https://github.com/sleekybadger/vending"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sleekybadger/vending"

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "tty-prompt", "~> 0.23"
end
