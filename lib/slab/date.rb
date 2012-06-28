module Slab
  module DateExt
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def epoch(name = nil)
        case name
        when :db then '1000-01-01'.to_date
        else
          Time.at(0).to_date
        end
      end
    end
    
    def end_of_month?
      self.month != self.advance(:days => 1).month
    end
    
    def on_end_of_month(&block)
      if end_of_month?
        yield(self)
      end
    end
    
  end
end

Date.send :include, Slab::DateExt
