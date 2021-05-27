# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/oraclecloud/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-oraclecloud"
  spec.version       = Fog::OracleCloud::VERSION
  spec.authors       = ["Joel Nation"]
  spec.email         = ["joel.nation@oracle.com"]

  spec.summary       = %q{Module for the 'fog' gem to support Oracle Cloud Services.}
  spec.description   = %q{This library can be used as a module for `fog` or as standalone provider to use the Oracle Cloud Service in applications.}
  spec.homepage      = "http://github.com/Joelith/fog-oraclecloud"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.2.10"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "shindo", "~> 0.3"
  spec.add_development_dependency "byebug", '~>9.0'

  spec.add_dependency 'fog-core',   '~> 1.38'
  spec.add_dependency 'fog-json',   '~>1.0'
  spec.add_dependency 'fog-xml',    '~>0.1'
  spec.add_dependency 'ipaddress',  '~>0.8'
  spec.add_dependency 'activesupport', '~>5.0'
end
