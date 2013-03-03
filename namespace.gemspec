# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'namespace/version'

Gem::Specification.new do |gem|
  gem.name          = "namespace"
  gem.version       = Namespace::VERSION
  gem.authors       = ["fntzr"]
  gem.email         = ["fantazuor@gmail.com"]
  gem.description   = "Add Namespace functionality"
  gem.summary       = "Include and Extend your class with Namespace. Create methods with the same name in different namespaces."
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(spec|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec', [">= 2.0.0"])
end
