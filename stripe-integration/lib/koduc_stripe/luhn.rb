module KsStripe
  # Validate the Card Number by Luhn Algorithm
  # 
  class KsLuhn
    # Validate the Card Number by Luhn Algorithm
    # 
    # == Parameter: Credit Card Number
    # == Retruns: true if card number is valid otherwise false
    def self.valid?(code)
      return false if (code.to_i==0)

      s1 = s2 = 0
      code.to_s.reverse.chars.each_slice(2) do |odd, even| 
        s1 += odd.to_i
     
        double = even.to_i * 2
        double -= 9 if double >= 10
        s2 += double
      end
      (s1 + s2) % 10 == 0
    end
  end
end