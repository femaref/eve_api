# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eve_api/version'

Gem::Specification.new do |gem|
  gem.name          = "eve_api"
  gem.version       = EveApi::VERSION
  gem.authors       = ["Femaref"]
  gem.email         = ["femaref@googlemail.com"]
  gem.description   = %q{Generic way to query the eve online api }
  gem.summary       = %q{Generic way to query the eve online api }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency("addressable", "~> 2.3.5")
  gem.add_dependency("nokogiri", "~> 1.6.0")
  gem.add_dependency("faraday", "~> 0.8.8") 
end
