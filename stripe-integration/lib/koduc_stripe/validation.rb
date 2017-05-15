module KsStripe
  # Validates the Credit Card details of user
  # 
  # All the errors are stored in `error_messages` instance variable 
  # 
  # == Example Usage
  # 
  # v_obj = KsStripe::KsValidation.new(
  #         {:name=>"Atul Khanduri",
  #          :card_number=>'4242424242424242',
  #          :cvc=>'123',
  #          :exp_month => 01,
  #          :exp_year => 2020,
  #          :card_type => 'visa'},
  #         12
  #         )
  # 
  # v_obj.valid_card?
  # 
  class KsCardValidation
    attr_accessor :error_messages

    # Initialize the `KsValidation` object with card's details and amount
    # 
    # == Parameters:
    #     Credit Card details in Hash having keys: name, card_number, cvc, exp_month,
    #       exp_year and card_type
    def initialize(options)
      @error_messages = []
      @options = options
      @success = true
    end

    # Check the validation on the Credit Card details and amount to be charged
    # 
    # == Parameter: None
    # == Returns:
    #     true if card is valid else false
    # == Returns: None


    # TODO: Check for valid month, must be integer and from 1 to 12
    def valid_card?
      # no need to go inside if all required
      # fields are not provided
      if has_all_keys?
        valid_number?
        valid_expiry_date?
        valid_cvc?
      end
      
      return @success
    end

    private
      # Check the Card details have all required keys (i.e Card Number, CVC, Expiry Month and Expiry Year)
      # 
      # == Parameter: None
      # == Returns: true if all the required keys are provided otherwise false
      def has_all_keys?
        if KsStripe::Empty.empty? @options
          @error_messages << "Please provide card details"
          @success = false
          return false
        end

        ["card_number", "cvc", "exp_month", "exp_year"].each do |k|
          unless @options.has_key? k.to_sym
            @error_messages << "Insufficient detail: Please provide #{get_key_type(k)}"
            @success = false
          end
        end
        return @success
      end

      # Validate the card number by Luhn Algorithm and Regex(if card type is provided)
      # 
      # == Parameter: None
      # == Returns: None
      def valid_number?
        luhn_valid? && valid_regex?
      end

      # Validate the card number by Luhn Algorithm
      # 
      # == Parameter: None
      # == Returns: None
      def luhn_valid?
        unless KsStripe::KsLuhn.valid?(@options[:card_number])
          @error_messages << "Invalid Card Number"
          @success = false
        end
      end

      # Validate the card number by Regex(if card type is provided)
      # Card type must be american_express, mastercard, visa, jcb, diners_club or discover
      # 
      # == Parameter: None
      # == Returns: None
      def valid_regex?
        supp_type = KsNumberCheck.supported_card_type

        if (@options.has_key? :card_type) && (supp_type.include? @options[:card_type].to_s.gsub(/\s/,'').downcase)
          unless KsNumberCheck.valid?(@options[:card_number], @options[:card_type])
            @error_messages << "Invalid Card Number"
            @success = false
          end
        end
      end

      # Validate the card expiration date
      # 
      # == Parameter: None
      # == Returns: None
      def valid_expiry_date?
        valid_exp_date = valid_exp_month?
        valid_exp_date = valid_exp_year?

        valid_date? if valid_exp_date
      end

      # Validate the format of expiry month
      # 
      # == Parameter: None
      # == Returns: True if valid month format otherwise false
      def valid_exp_month?
        if ((@options.has_key? :exp_month) && (@options[:exp_month].to_s =~ /^(0?[1-9]|1[012])$/))
          return true
        else
          @error_messages << "Invalid Card Expiration Month"
          @success = false
          return false
        end
      end

      # 
      # 
      # == Parameter: None
      # == Returns: True if valid year format otherwise false
      # 
      def valid_exp_year?
        if ((@options.has_key? :exp_year) && (@options[:exp_year].to_s =~ /^\d{4}$/))
          return true
        else
          @error_messages << "Invalid Card Expiration Year"
          @success = false
          return false
        end

        @options.has_key? :exp_year
      end

      # Validate the card Expired Date which must be greater than current date
      # 
      # == Parameter: None
      # == Returns: None
      def valid_date?
        y = Date.today.year

        unless (@options.has_key? :exp_year) && ((y<@options[:exp_year].to_i) || (y==@options[:exp_year].to_i && valid_month?))
          @error_messages << "Invalid Card Expiration Date"
          @success = false
        end
      end

      # Compare the Card's expiry month with current month
      # 
      # == Parameter: None
      # == Returns: True if card's expiry month is equal or greater than current month
      def valid_month?
        m = Date.today.month

        if @options.has_key? :exp_month && m>@options[:exp_month].to_i
          return false
        end
        return true
      end

      # Validate the card CVC number which must be of 3 digits
      # 
      # == Parameter: None
      # == Returns: None
      def valid_cvc?
        # CVC must be a valid 3 digit number
        unless (@options.has_key? :cvc) && (@options[:cvc].to_s.length==3) && (@options[:cvc].to_s.count("0-9")==3)
          @error_messages << "Invalid CVC"
          @success = false
        end
      end

      # Gives the type in Human Readable form
      # 
      # == Parameter: type of the key
      # == Returns: The type in Human Readable form
      def get_key_type(type)
        case type
        when "card_number"
          "Card number"
        when "cvc"
          "CVC"
        when "exp_month"
          "Card Expiration Month"
        when "exp_year"
          "Card Expiration Year"
        else
          ""
        end
      end
  end

  class KsValidation
    class<<self

      # Check the validity of amount which must be a positive integer
      # 
      # == Parameter: Amount(in cents)
      # == Returns: true if valid Amount else false
      def valid_amount?(amt)
        if ((amt.is_a? Float) || (amt.to_i <= 0))
          return false
        else
          return true
        end
      end

      # Check the validity Refund Reason.
      # Reason must be one of duplicate, fraudulent or requested_by_customer
      # 
      # == Parameter: Refund reason
      # == Returns: true if valid reason else false
      def valid_refund_reason?(reason)
        if (KsStripe::Empty.empty?(reason)) || (['duplicate','fraudulent','requested_by_customer'].include? reason.to_s.strip)
          return true
        else
          return false
        end
      end

      # Check if Stripe Key is provided
      # 
      # Raise exception if no key is provided
      # == Parameter: None
      # == Returns: None
      def has_stripe_key?
        KsStripe::Client.get_key_header
      end
    end
  end
end