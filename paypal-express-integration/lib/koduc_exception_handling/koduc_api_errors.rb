# Module is loaded so as to raise the Api Errors 
# Inherit from the StandardError class
# StandardError deals with application level errors
# Avoiding the risk of catching errors that deals with the environment
# Instantiate the KsAPIErrors class and initialize the object's constructor
# Call ks_error_messages method to provide a format to the Error messages raised through API


module KsExceptionHandling
	class KsAPIErrors < StandardError
		
		attr_accessor :ks_response 

		def initialize(ks_response)
			@response_array = []
			@ks_response = ks_response
		end 

		def ks_error_messages
			@response_array << ks_response
			response = {success: false ,response:@response_array}
		end

	end			
end
