# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'koduc_stripe/version'

Gem::Specification.new do |spec|
  spec.name          = "koduc_stripe"
  spec.version       = KsStripe::VERSION
  spec.authors       = ["Koduc"]
  spec.email         = ["ratan@ksolves.com"]

  spec.summary       = "KsStripe is a Ruby Gem for Stripe Payment Gateway Integration"
  spec.description   = "KsStripe provides a platform to integrate Stripe payment gateway in Ruby on Rails Application"
  spec.homepage      = "https://github.com/kartiksolves/koduc-stripe"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.3'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  # Rails >=3.2 supports Ruby 1.9.3 (http://edgeguides.rubyonrails.org/3_2_release_notes.html)
  spec.add_dependency 'activesupport', '>= 3.2'
  spec.add_dependency "rest-client", '~> 1.4'
end
