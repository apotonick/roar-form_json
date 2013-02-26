# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roar/representer/json/form/version'

Gem::Specification.new do |gem|
  gem.name          = "roar-form_json"
  gem.version       = Roar::Representer::JSON::Form::VERSION
  gem.authors       = ["Nick Sutterer"]
  gem.email         = ["apotonick@gmail.com"]
  gem.description   = %q{Representers for the json+form media type.}
  gem.summary       = %q{Representers for the json+form media type.}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"

  gem.add_dependency "roar", ">= 0.11.10"
end
