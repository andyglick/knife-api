# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife/api/version'

Gem::Specification.new do |gem|
  gem.name          = 'knife-api'
  gem.version       = Chef::Knife::API::VERSION
  gem.authors       = ['Erik Hollensbe', 'Andy Glick', 'James La Spada']
  gem.email         = ['andyglick@gmailcom']
  gem.description   = "A small library that lets you drive Chef's 'knife' programmatically"
  gem.summary       = "A small library that lets you drive Chef's 'knife' programmatically"
  gem.homepage      = 'https://github.com/andyglick/knife-api'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'chef', '>= 10.32', '<= 12.6.0'
  gem.add_dependency 'chef-zero', '>= 2.2.1'
  gem.add_dependency 'ohai', '> 7.0.0', '< 9.0.0'
  gem.add_dependency 'json', '>= 1.8.2'

  gem.add_development_dependency 'rake', '>= 10.4.2'
  gem.add_development_dependency 'codeclimate-test-reporter', '>= 0.4.8' # , group: :test, require: nil
end
