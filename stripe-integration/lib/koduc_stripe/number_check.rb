# Validate the Card Number by Regular Expression
# 
# Only Cards that have type american_express, mastercard, visa, jcb,
# diners_club or discover are supported as they are supported by Stripe
# 
class KsNumberCheck

  CARD_TYPES = {
    :american_express => /^3[47][0-9]{5,}$/,
    :mastercard => /^5[1-5][0-9]{14}$/,
    :visa => /^4[0-9]{12}(?:[0-9]{3})?$/,
    :jcb => /^(?:2131|1800|35\d{3})\d{11}$/,
    :diners_club => /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/,
    :discover => /^6(?:011|5[0-9]{2})[0-9]{12}$/
  }

  class << self
    # Validate the Card Number by Regex
    # 
    # == Parameter:
    #     Credit Card Number
    #     Card Type
    # == Returns: true if card is valid otherwise false
    def valid?(number,type)
      number.to_s.gsub(/\s/,'') =~ CARD_TYPES[type.to_s.downcase.to_sym]
    end

    # Gives all the suuported card types
    # 
    # == Parameter: None
    # == Returns: All the suuported card types
    def supported_card_type
      CARD_TYPES.keys.map{|t| t.to_s}
    end
  end
end