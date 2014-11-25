# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mimicus/version'

Gem::Specification.new do |spec|
  spec.name          = "mimicus-agent"
  spec.version       = Mimicus::VERSION
  spec.authors       = ["mardek"]
  spec.email         = ["martial.ndeko@gmail.com"]
  spec.summary       = ["Monitoring Solution, Cloud Oriented based on Ruby and Redis"]
  spec.description   = ["Server/Agent daemon monitoring tools for Linux and BSD"]
  spec.homepage      = "https://github.com/mardek/mimicus"
  spec.license       = "GPL3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) } 
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sysinfo'
  spec.add_dependency 'vmstat'
  spec.add_dependency 'process'
  spec.add_dependency 'usagewatch'
  spec.add_dependency 'rest_client'

  #spec.add_dependency 'yaml'

  spec.required_ruby_version = ">= 1.9.7"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake" , "~> 10.0"
end
