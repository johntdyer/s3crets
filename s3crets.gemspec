# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3crets/version'

Gem::Specification.new do |gem|
  gem.name          = "s3crets"
  gem.version       = S3crets::VERSION
  gem.authors       = ["John Dyer"]
  gem.email         = ["jdyer@voxeolabs.com"]
  gem.description   = %q{foo}
  gem.summary       = %q{foo}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib","bin"]

    gem.add_dependency 'rake'
    gem.add_dependency 'json'
    gem.add_dependency 'rainbow'
end
