module KsStripe
  class Error
    class<<self

      # Handle Standard Error
      # 
      # == Parameter: `StandardError` type object caught in Exceiption
      # 
      # == Returns: The Error in hash
      def internal_error(e)
        # begin
          # msg = e.message
          # return format_error(msg)
        # rescue
          format_error("Internal Error. Please try after again later.")
        # end
      end

      # Handle the error received from Stripe
      # 
      # == Parameter: `RestClient::Exception` type object caught in Exceiption
      # 
      # == Returns: The Error in hash
      def response_api_error(resp)
        begin
          e = JSON.parse(resp.response.body)
          msg = e['error']['message']
          format_error(msg)
        rescue JSON::ParserError => e
          json_error(e)
        rescue => e
          internal_error(e)
        end
      end

      # Handle the invalid response received from Stripe
      # 
      # == Parameters: `JSON::ParserError` type object caught in Exceiption
      # 
      # == Returns:  The Raw hash received from Stripe
      def json_error(resp)
        msg = 'Invalid response received from the Stripe API. Please contact support@stripe.com if you continue to receive this message.'
        msg += " (The raw response returned by the API was #{resp.inspect})"
        format_error(msg)
      end

      # Format the error message in Array of Hash
      # with the provided message
      # 
      # == Parameter: Error message
      # == Returns: Error message in hash
      def format_error(err)
        case err
        # when String  
          # (err_arr ||= []) << err
        when Array  
          err_arr = err.flatten
        else  
          (err_arr ||= []) << err
        end

        {
          "error" => {
            "message" => err_arr
          }
        }
      end
    end
  end
end