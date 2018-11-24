# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'namespace/version'

Gem::Specification.new do |gem|
  gem.name          = "name_space"
  gem.version       = Namespace::VERSION
  gem.authors       = ["fntz"]
  gem.email         = ["mike.fch1@gmail.com"]
  gem.description   = "Add Namespace functionality"
  gem.summary       = "Include and Extend your class with Namespace. Create methods with the same name in different namespaces."
  gem.homepage      = 'https://github.com/fntz/namespace'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(spec|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec', '~> 2.0', '>= 2.0.0'
end
