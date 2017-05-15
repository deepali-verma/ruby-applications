# TODO: Create a new file `payment.rb` and move all
# necessary code to that file.

module KsStripe
  # A `KsBase` object represents a physical credit card, and is capable of validating and charging
  # the card in Stripe.
  # 
  # Amount to be charge must be in cents and supports only US Dollars.
  # 
  # == Example Usage
  # 
  # card_obj = KsStripe::KsBase.new(
  #         :card_number=>'4242424242424242',
  #         :cvc=>'123',
  #         :exp_month => 01,
  #         :exp_year => 2020,
  #         :card_type => 'visa',
  #         :name=>"Atul Khanduri"
  #         )
  # 
  # charge = card_obj.charge(10, "This is a test payment by KsStripe Gem")
  # 
  class KsBase
    cattr_accessor :options, :errors

    # Check for Stripe API Key and if provided then
    # initialize a KSBase object with provided Card Details
    # 
    # == Parameters:
    #   Parameter should be a Hash with below keys:
    #     card_number  => (Required)
    #     cvc          => (Required)
    #     exp_month    => (Required)
    #     exp_year     => (Required)
    #     name         => (Optional)
    #     card_type    => (Optional)
    #
    #   * card_type can only be american_express, mastercard, visa, jcb, diners_club or discover
    #     as Stripe supports only these cards.
    #   * If card_type is provided then only Card is Validated using Regular expression.
    #     Although Luhn Algorithm is always applied to verify Card.
    # 
    # Returns: None
    def initialize(options={})
      KsStripe::KsValidation.has_stripe_key?

      @options = options.symbolize_keys
      @errors = []
    end

    # Check the Validation of the Card
    # Errors are stored in @errors
    # 
    # == Parameter:
    #     Amount(in cents) to be charge
    # == Returns:
    #     true if card and amount is valid else false
    def valid?(amt)
      @errors = []
      v = KsStripe::KsCardValidation.new(@options)

      if !v.valid_card?
        @errors << v.error_messages
        success = false
      elsif !(KsStripe::KsValidation.valid_amount?(amt))
        @errors << "Invalid Amount. Please provide a non-zero integer."
        success = false
      else
        success = true
      end

      return success
    end

    # Charge the card by using the object of KsBase class
    # 
    # == Parameters:
    #     Amount(in cents) to be charge in positive integer number (Required)
    #     Description of the payment (optional)
    # == Returns:
    #     The response received from Stripe if payment is successfull
    #     otherwise error from local validation or from Stripe
    def charge(amt, desc="")
      unless valid?(amt)
        return KsStripe::Error.format_error(@errors)
      end

      req_hash = {}
      begin
        req_hash.merge!({"amount"=>amt})
        req_hash.merge!({"currency"=>'usd'})
        req_hash.merge!({"source"=>KsStripe::KsRequest.get_stripe_token(@options)})
        req_hash.merge!({"description"=>desc}) unless KsStripe::Empty.empty? desc
      rescue => e
        resp = KsStripe::Error.internal_error(e)
      else
        resp = KsStripe::KsRequest.request_api("https://api.stripe.com/v1/charges", req_hash)
      end

      return resp
    end

    # Partially or Completely Refund a payment by using charge id
    # 
    # == Parameters:
    #     Charge Id => Charge id to be refunded (Required)
    #     Amount => Amount (in cents) to be refunded (Optional)
    #     Reason => Reason of the Refund (Optional)
    #      * If Amount is not provided then complete amount is refunded
    #        else Partially amount is refunded
    #      * Reason must be one of duplicate, fraudulent or requested_by_customer
    # == Returns:
    #     The response received from Stripe if payment is successfull
    #     otherwise error from local validation or from Stripe
    def self.refund(charge_id, amount='', reason='')
      errors = []
      success = true
      
      if ((amount.present?) && !(KsStripe::KsValidation.valid_amount?(amount)))
        errors << "Invalid Amount. Please provide a non-zero integer."
        success = false
      end

      unless KsStripe::KsValidation.valid_refund_reason?(reason)
        errors << "Invalid reason: Reason must be one of duplicate, fraudulent or requested_by_customer"
        success = false
      end

      return KsStripe::Error.format_error(errors) unless success

      req_hash = {}
      begin
        req_hash.merge!({"charge"=>charge_id})
        req_hash.merge!({"amount"=>amount}) unless KsStripe::Empty.empty? amount
        req_hash.merge!({"reason"=>reason}) unless KsStripe::Empty.empty? reason
      rescue => e
        resp = KsStripe::Error.internal_error(e)
      else
        resp = KsStripe::KsRequest.request_api("https://api.stripe.com/v1/refunds", req_hash)
      end

      return resp
    end
  end
end