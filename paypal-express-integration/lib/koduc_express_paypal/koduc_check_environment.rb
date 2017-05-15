module KsCheckEnvironment

	# Declare the Endpoints according to the environment
	# Endpoints are required to make a post call through Rest Client
	# the constant ks_production holds the endpoint for making API call with live credentials
	# the constant ks_sandbox holds the endpoint for making API call with sandbox credentials
	KSENDPOINT = 
		{ 
			:ks_production=> 'https://api-3t.paypal.com/nvp',
			:ks_sandbox=> 'https://api-3t.sandbox.paypal.com/nvp'
		}

	# @@ks_sandbox : A class variable that will decide the environment
	# Set boolean value for this variable before making an API call
	# Default is set for sandbox
	# true for sandbox
	# false for production
	@@ks_sandbox = true

	# Call this method to check the value of ks_sandbox variable after initialization
	def self.ks_sandbox?
		@@ks_sandbox
	end

	# Call this method to set the environment 
	# pass ks_boolean_value as true for sandbox 
	# And false for Live environemnt
	def self.ks_sandbox(ks_boolean_value)
		@@ks_sandbox = ks_boolean_value
	end

	# Invoke this method to set the endpoints according to the value of ks_sandbox variable
	def self.ks_endpoint
		if ks_sandbox?
			KsCheckEnvironment::KSENDPOINT[:ks_sandbox]
		else
			KsCheckEnvironment::KSENDPOINT[:ks_production]	
		end
	end

end	