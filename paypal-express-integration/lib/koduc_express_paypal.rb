# First file to be loaded when the gem is invoked.
# Need to require everything here
# Fetch all the configuration values here

require "koduc_express_paypal/version"
require "koduc_express_paypal/koduc_check_environment"
require "koduc_express_paypal/koduc_request"
require "koduc_express_paypal/koduc_validation"
require "koduc_express_paypal/koduc_response"
require "koduc_exception_handling/koduc_api_errors"
require "koduc_refund/koduc_refund"
require "koduc_refund/koduc_refund_validation"
require "active_support"
require "active_support/core_ext"
require "rest_client"

# Declare a constant api_version
# This is the release version of the developing API used in this gem
# One of the parameters mandatory for each call
# No need to pass it from the user's side
# Keep it here and change it from here
module KsExpressPaypal
 	mattr_accessor :api_version
 	self.api_version = '88.0'
 	
 	# Method to take the paypal credentials
	# The credentials must be included in the app 
	# Merge the VERSION declared in the KsExpressPaypal module 
	# Value of the VERSION is declared as constant 
 	def self.ks_merchants_details
 		begin
			ks_merchants_details = Rails.configuration.paypal_credentials.merge(VERSION: KsExpressPaypal.api_version)
		rescue => exc
			if !exc.message.nil?
				error =  KsExceptionHandling::KsAPIErrors.new(exc.message)
				error.ks_error_messages
			end
		end
	end
end