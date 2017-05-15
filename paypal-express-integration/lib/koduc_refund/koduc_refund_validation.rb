# To validate the refund parameters
# transaction_id => id of the transaction that needs to be refunded (mandatory for both partial and full refund)
# amount => The amount to be refunded in case of partial payments
# currency_code => The currency code required only in case of partial paymanets
# note => Description of the partial payment
# ks_error => Array that will hold the error messages.

class RefundValidation

	attr_accessor :transaction_id, :amount, :currency_code, :note, :ks_error

	# Default constructor of the class
	def initialize(transaction_id,amount,currency_code,note)
		@transaction_id = transaction_id
		@amount = amount
		@currency_code = currency_code
		@note = note
		@ks_error = []
	end

	# Method invoke so as to check the validity of the parameters passed
	def check_validity
		success = true
		if !empty_transaction_id? 
			success = false
		else
			if !amount.blank? && !currency_code.blank?
				success = false if !check_payment_amount? 
				success = false if !payment_number? 
				success = false if !currency_code? 
			end
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

	# Check for the empty transaction id
	# Returns true for the success if verified else false with error message
	def empty_transaction_id?
		if transaction_id.blank? 
			ks_error << "Missing Parameters : Transaction Id can not be blank."
			puts "Check for transaction id is failed."
			success = false
		else
			puts "Check for transaction id is successful."
			success = true		
		end
		return success
	end

	# Invoke the below method to check if the payment amount is smaller than or equals to zero
	# Returns the value of success accordingly
	def check_payment_amount?
		if !amount.blank?
			payment_amount = amount.to_i
			if !(payment_amount <= 0)
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
		if !amount.blank?
			if amount =~ /\A[-+]?\d*\.?\d+\z/
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

	# Check if the currency code is invalid (contains capital letters)
	# Returns true and false accordingly
	# Returns the error message
	def currency_code?
		if !currency_code.blank?
			if currency_code.match(/^[A-Z]+$/)
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