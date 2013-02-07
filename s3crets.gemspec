# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3crets/version'

Gem::Specification.new do |gem|
  gem.name          = "s3crets"
  gem.version       = S3crets::VERSION
  gem.authors       = ["John Dyer"]
  gem.email         = ["jdyer@voxeolabs.com"]
  gem.description   = %q{Applys yaml secrets against Chef JSON files }
  gem.summary       = %q{s3crets looks for a YAML config file and performs a deep merge against a directory of json files but only if the top level yaml key is present in the destination JSON file.  This ensures your secrets are only merged into the files you intended.  The purpose of s3crets was to help us keep secrets out of configuration JSON, which is kept in source control.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib","bin"]

    gem.add_dependency 'rake'
    gem.add_dependency 'json'
    gem.add_dependency 'rainbow'
end
