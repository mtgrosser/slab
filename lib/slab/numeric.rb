module Slab
  module NumericExt
    
    class DiscountTooBig < StandardError; end
    
    def percent
      self / 100.0
    end
    
    def discount(factor)
      raise DiscountTooBig if factor > 1
      self * (1.0 - factor)
    end
    
    def net(tax_factor)
      self / (1.0 + tax_factor)
    end
    
    def gross(tax_factor)
      self * (1.0 + tax_factor)
    end
    
    def tax(factor)
      self * factor.to_f
    end
    
    def commercial_round
      (self * 100.0).round / 100.0
    end
    
    def sgn
      if self > 0
        1
      elsif self == 0
        0
      else
        -1
      end
    end
  end
end

Numeric.send :include, Slab::NumericExt
