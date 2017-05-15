# Methods of the module will validate the parameters passed by the user
# Initialise the object's constructor of the class
# ks_merchants_details 	=>		For holding the paypal credentials
# ks_payment_details	=>		For holding the payment details
# ks_redirect_urls		=>		For holding the redirect URLS
# ks_error				=>		Array for holding the error messages

module KsAPIValidation
	class KsValidation

		attr_accessor :ks_merchants_details, :ks_payment_details, :ks_redirect_urls, :ks_error

		def initialize(ks_merchants_details,ks_payment_details,ks_redirect_urls)
			@ks_merchants_details = ks_merchants_details
			@ks_payment_details = ks_payment_details
			@ks_redirect_urls = ks_redirect_urls
			@ks_error = []
		end


		# It is the first method that is to be called to check the validity of the parameters
		# The method invokes all the methods of validation and return true if the parameters are verified 
		def check_validity
			success = true
			if !empty_values? 
				success = false
			else
				success = false if !paypal_credentials? 
				success = false if !mandatory_paypal_details? 
				success = false if !mandatory_payment_details? 
				success = false if !mandatory_url_details? 
				success = false if !check_payment_amount? 
				success = false if !payment_number? 
				success = false if !payment_action? 
				success = false if !currency_code? 
			end
			response = validate_response(success)
			return response	
		end

		# It returns the response in both the cases (success or failure)
		# The format of response is {success: true/false, error_messages: array of the error messages(blank if success is true)}
		# Check the uniqueness of the array of the error messages with uniq keyword
		def validate_response(success)
			unique_errors = ks_error.uniq
			response = {success:success,response:unique_errors}	
			return response
		end

		# The method below checks if the parameters passed are completely empty or not
		# Returns true and false accordingly
		def empty_values?
			if ks_merchants_details.empty? 
				ks_error << 'Missing Parameters : Paypal credentials are missing.'
				puts "Check for Empty values is failed."
				success = false
			else
				puts "Check for Empty values is successful."
				success = true
			end
			return success		
		end

		# The method checks the keys passed by the user in the paypal credentials are correct or not.
		# These are necessary else the API will through error
		# Returns true and false accordingly 
		# If false the Error message will be stored in the ks_error 
		def paypal_credentials?
			if [:USER, :PWD, :SIGNATURE].all? { |s| ks_merchants_details.key? s  }
				success = true
				puts "Check for the keys of Paypal Credentials is successful."
			else
				ks_error << 'Keys Missing : Some of the keys in Paypal credentials are missing.'
				success = false
				puts "Check for the keys of Paypal Credentials is failed."
			end
			return success
		end

		# Check if all the mandatory keys in the Paypal credentials have values
		# Returns true or false accordingly
		# Error message if false
		def mandatory_paypal_details?
		 	if ks_merchants_details[:USER].blank? || ks_merchants_details[:PWD].blank? || ks_merchants_details[:SIGNATURE].blank? || ks_merchants_details[:VERSION].blank?
		 		ks_error << 'Paypal Credentials : Mandatory fields cannot be blank.'
				success = false
				puts "Check for the mandatory paypal credentials is failed."
			else
		 		success = true
		 		puts "Check for the mandatory paypal credentials is successful."
		 	end
		 	return success
		end

		# Check if all the mandatory keys in the Payment have values
		# Returns true or false accordingly
		# Error message if false
		def mandatory_payment_details?
			if ks_payment_details[:PAYMENTREQUEST_0_AMT].blank? || ks_payment_details[:PAYMENTREQUEST_0_PAYMENTACTION].blank? || ks_payment_details[:PAYMENTREQUEST_0_CURRENCYCODE].blank?
				ks_error << 'Payment Details : Mandatory fields cannot be blank.'
				success = false
				puts "Check for mandatory payment details is failed."
			else
				success = true
				puts "Check for mandatory payment details is successful."
			end
			return success
		end

		# Check if all the mandatory keys in the Redirect URLS have values
		# Returns true or false accordingly
		# Error message if false
		def mandatory_url_details?
			if ks_redirect_urls[:cancelUrl].blank? || ks_redirect_urls[:returnUrl].blank?
				ks_error << ' Redirect URLS : Mandatory fields cannot be blank.'
				success = false
				puts "Check for mandatory redirect urls is failed."
			else
				success = true
				puts "Check for mandatory redirect urls is successful."
			end
			return success
		end

		# Invoke the below method to check if the payment amount is smaller than or equals to zero
		# Returns the value of success accordingly
		def check_payment_amount?
			if !ks_payment_details[:PAYMENTREQUEST_0_AMT].blank?
				amount = ks_payment_details[:PAYMENTREQUEST_0_AMT].to_i
				if !(amount <= 0)
					success = true
					puts "Check for payment amount is successful"
				else	
					ks_error << "Payment Amount is invalid."
					success = false
					puts "Check for payment Amount is failed."
				end
				return success
			end	
		end

		# Check if the string passed consists of only numbers and the decimal values 
		# Returns true and false accordingly
		# Returns the error message if success is false
		def payment_number?	
			if !ks_payment_details[:PAYMENTREQUEST_0_AMT].blank?
				if ks_payment_details[:PAYMENTREQUEST_0_AMT] =~ /\A[-+]?\d*\.?\d+\z/
					success = true
					puts "Check for payment amount is successful."
				else	
					ks_error << "Payment Amount is invalid."
					success = false
					puts "Check for payment amount is failed."
				end
				return success
			end	
		end

		# Check if the string passed consists of only alphabets and the decimal values 
		# Returns true and false accordingly
		# Returns the error message if false
		def payment_action?
			if !ks_payment_details[:PAYMENTREQUEST_0_PAYMENTACTION].blank?
				if ks_payment_details[:PAYMENTREQUEST_0_PAYMENTACTION].match(/^[a-zA-Z]+$/)
					success = true
					puts "Check for payment action is successful."
				else
					ks_error << 'Payment Action is invalid.'
					success = false
					puts "Check for payment action is failed."
				end	
				return success	
			end
		end

		# Check if the currency code is invalid (contains capital letters)
		# Returns true and false accordingly
		# Returns the error message
		def currency_code?
			if !ks_payment_details[:PAYMENTREQUEST_0_CURRENCYCODE].blank?
				if ks_payment_details[:PAYMENTREQUEST_0_CURRENCYCODE].match(/^[A-Z]+$/)
					success = true
					puts "Check for currency code is successful."
				else
					ks_error << 'Currency Code is invalid'
					success = false
					puts "Check for currency code is failed."
				end
				return success
			end
			
		end

	end	
end	