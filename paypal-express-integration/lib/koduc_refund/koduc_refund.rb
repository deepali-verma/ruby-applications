# The file is loaded so as to refund the transaction
# Initialize the object's constructor first
# Refund could be Full or Partial
# transaction_id => The transaction id for which the refund is to be made(required in both Full and Partial payments)
# amount => The amount in case of partial refund
# currency_code => The currency code required in case of partial refund
# note => The description of the partial refund
# refund_type => The refund type 'Full' or 'Partial'

module KsAPIRefund

	class KsRefund

		attr_accessor :transaction_id, :params, :amount, :currency_code, :note, :refund_type

		# Class default constructor
		def initialize(params)
			@transaction_id = params[:transaction_id]
			@amount = params[:amount]
			@currency_code = params[:payment_currency]
			@note = params[:note]
			@refund_type = ''
		end

		# Method will check the validity of the parameters initialised with the help of the constructor
		# Form a new object of the RefundValidation class
		# Returns the response fetched from the check_validity method
		def valid?
			obj= RefundValidation.new(transaction_id,amount,currency_code,note)
			response = obj.check_validity
			return response
		end

		# Check for the refund type
		# If amount, currency code and note are blank, it will be 'Full'
		# Else it will be partial
		# Returns the refund type
		def refund_type?
			if amount.blank? && currency_code.blank? && note.blank?
				refund_type = 'Full'
			else
				refund_type = 'Partial'	
			end
			return refund_type
		end

		# Returns the parameters for the partial payment
		def partial_params
		    partial_params = {
		      		:AMT => amount,
		      		:CURRENCYCODE => currency_code,
		      		:NOTE => note
		      	}
		    return partial_params
		end

		# Returns the transaction id in the hash format
		def transaction
			transaction = {
				:TRANSACTIONID=>transaction_id
			}
			return transaction
		end

		# Method to invoke the refund functionality 
		# If the refund type is 'full' dont merge the amount, currency code and note
		# Check the validity of the parameters first
		# If response[:success] is true call the Refund API
		# Else return the response obtained from the valid? method
		def ks_refund
			env = KsCheckEnvironment::ks_sandbox(false)
			response = valid?
			if response[:success]
				refund_type = refund_type?
				case refund_type
	        		when 'Full'
	          			ks_response = KsExpressPaypal::KsRequest.ks_request :RefundTransaction,KsExpressPaypal.ks_merchants_details.merge(transaction).merge(:REFUNDTYPE=>refund_type)
	        		else
	        			ks_response = KsExpressPaypal::KsRequest.ks_request :RefundTransaction,KsExpressPaypal.ks_merchants_details.merge(transaction).merge(:REFUNDTYPE=>refund_type).merge(partial_params)
	        		end	
			else
				return response	
			end	
		end

	end	
end		