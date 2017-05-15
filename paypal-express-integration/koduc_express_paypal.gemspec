# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'koduc_express_paypal/version'

Gem::Specification.new do |spec|
  spec.name          = "koduc_express_paypal"
  spec.version       = KoducExpressPaypal::VERSION
  spec.authors       = ["Koduc"]
  spec.email         = ["ratan@ksolves.com"]

  spec.summary       = "Gem deals with express checkout one time Paypal Payment using NVP Gateway with partial and full refunds."
  spec.description   = "koduc_express_paypal is a simple gem used for Paypal Payment Gateway integration with partial and full refunds. This gem is written by KSolves. The main aim of this project is to deal with the one time Paypal payment using express checkout method using NVP(Name Value Pair). One can also make partial and full refunds."
  spec.homepage      = "https://github.com/kartiksolves/koduc-paypal-express"
  spec.license       = "MIT"

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

  # Specify the minimum version of the ruby
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  # Add run time dependency of the following gems 
  # required for building the express checkout using NVP
  spec.add_dependency 'activesupport', '>=3.2'
  spec.add_dependency "rest-client", '~> 1.4'
end
