# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife/api/version'

Gem::Specification.new do |gem|
  gem.name          = "knife-api"
  gem.version       = Chef::Knife::API::VERSION
  gem.authors       = ["Erik Hollensbe", "Andy Glick"]
  gem.email         = ["andyglick@gmailcom"]
  gem.description   = %q{A small library that lets you drive Chef's 'knife' programmatically}
  gem.summary       = %q{A small library that lets you drive Chef's 'knife' programmatically}
  gem.homepage      = "https://github.com/andyglick/knife-api"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'chef', '~> 10.0', '< 12.0.0'
end
