module KsStripe
  # Check value is empty or not
  # 
	class Empty

    class << self
      # Check value is empty or not
      # 
      # == Parameter: Value to be checked
      # == Returns: true if value is empty else false
  		def empty?(value=nil)
        case value
        when nil
          true
        when Array, Hash
          value.empty?
        when String
          value.strip.empty?
        when Numeric
          (value == 0)
        else
          false
        end
      end
    end
	end
end