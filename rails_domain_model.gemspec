
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails_domain_model/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_domain_model"
  spec.version       = RailsDomainModel::VERSION
  spec.authors       = ["Anders Lemke"]
  spec.email         = ["mail@anderslemke.dk"]

  spec.summary       = "An opinionated domain layer for Ruby on Rails."
  spec.description   = "Get control of your domain model with Event Sourcing, CQRS and core concepts from Domain-Driven Design. RailsDomainModel provides an opinionated domain layer for Rails."
  spec.license       = "LGPL-3.0"
  spec.homepage      = 'http://rubygems.org/gems/rails_domain_model'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency             "rails_event_store", "~> 0.34"
  spec.add_dependency             "sneakers", "~> 2.7"
end
