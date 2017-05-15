module KsStripe
  class KsRequest
    class<<self
      
      # Calls Stripe's API
      # 
      # == Parameter: API URL to be requested, Parameter Hash for request
      # == Returns:
      #     The response received from Stripe if payment is successfull
      #     otherwise error from local validation or from Stripe
      def request_api(req_url, params_hash)
        begin
          resp = RestClient.post(req_url,
                                params_hash,
                                {"Authorization"=>KsStripe::Client.get_key_header})

          resp = JSON.parse(resp)
        rescue JSON::ParserError => e
          resp = KsStripe::Error.json_error(e)
        rescue RestClient::Exception => e
          resp = KsStripe::Error.response_api_error(e)
        rescue => e
          resp = KsStripe::Error.internal_error(e)
        end
      end
      
      # Generates a one-time usage Stripe Token
      # by calling Stripe's API
      # 
      # == Parameter: None
      # == Returns: The token received from Stripe
      def get_stripe_token(options)

        req_hash = {'card[number]'=>options[:card_number],
                    'card[exp_month]'=>options[:exp_month],
                    'card[exp_year]'=>options[:exp_year],
                    'card[cvc]'=>options[:cvc]}

        req_hash.merge!({'card[name]'=>options[:name]}) unless KsStripe::Empty.empty? options[:name]

        #   token_obj = RestClient.post("https://api.stripe.com/v1/tokens",
        #                             { 'card[number]'=>options[:card_number],
        #                               'card[exp_month]'=>options[:exp_month],
        #                               'card[exp_year]'=>options[:exp_year],
        #                               'card[cvc]'=>options[:cvc]},
        #                             {'Authorization'=>KsStripe::Client.get_key_header})
        # else
        #   token_obj = RestClient.post("https://api.stripe.com/v1/tokens",
        #                             { 'card[number]'=>options[:card_number],
        #                               'card[exp_month]'=>options[:exp_month],
        #                               'card[exp_year]'=>options[:exp_year],
        #                               'card[cvc]'=>options[:cvc],
        #                               'card[name]'=>options[:name]},
        #                             {'Authorization'=>KsStripe::Client.get_key_header})
          token_obj = RestClient.post("https://api.stripe.com/v1/tokens",
                                    req_hash,
                                    {'Authorization'=>KsStripe::Client.get_key_header})
        # end

        token_obj = JSON.parse(token_obj)
        stripe_token = token_obj['id']

        return stripe_token
      end
    end
  end
end