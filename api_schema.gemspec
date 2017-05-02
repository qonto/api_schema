# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_schema/version'

Gem::Specification.new do |spec|
  spec.name          = "api_schema"
  spec.version       = ApiSchema::VERSION
  spec.authors       = ["Dmitry Chopey"]
  spec.email         = ["dmitry.chopey@gmail.com"]

  spec.summary       = %q{api_schema provides a framework and DSL for describing APIs
                          and generate swagger json.}
  spec.description   = %q{api_schema provides a framework and DSL for describing APIs
                          and generate swagger json using minimalist, schema.db-like syntax.}
  spec.homepage      = "https://github.com/qonto/api_schema."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "swagger-blocks", "~> 2.0"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
