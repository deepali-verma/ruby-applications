require "active_support"
require "active_support/core_ext"
require "rest_client"

require "koduc_stripe/base"
require "koduc_stripe/empty"
require "koduc_stripe/error"
require "koduc_stripe/luhn"
require "koduc_stripe/number_check"
require "koduc_stripe/validation"
require "koduc_stripe/version"
require "koduc_stripe/request"

module KsStripe
  # Set the Stripe API key
  # 
  class Client
    cattr_reader :stripe_token

    class << self
      # Set the Stripe API key to a class variable
      # 
      # 
      # == Parameter: A block of code having Stripe API Key
      # == Returns: None
      def configure(&block)
        config = OpenStruct.new
        block.call config

        # if config[:stripe_api_key].blank?
        #   raise "No Stripe API key provided."
        # elsif KsStripe::Empty.empty?(config[:stripe_api_key])
        if KsStripe::Empty.empty?(config[:stripe_api_key])
          raise "No Stripe API key provided. Please initialize the App with valid stripe API key."
        end
        
        @@stripe_token = config[:stripe_api_key]
      end

      # Gives the Stripe API Key
      # 
      # == Parameter: None
      # == Returns: Stripe API Key
      def stripe_key
        return @@stripe_token
      end

      # Gives Stripe Authorization Header for Stripe API request
      # 
      # == Parameter: None
      # == Returns: If stripe key is provided then return Stripe Authorization Header
      #     otherwise Raise exception.
      def get_key_header
        if KsStripe::Empty.empty?(self.stripe_key)
          raise "No Stripe API key provided. Please initialize the App with valid stripe API key."
        end
        @@stripe_auth_key = "Bearer #{self.stripe_key}"
      end

    end
  end
end
