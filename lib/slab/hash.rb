module Slab
  module HashExt
    def hmap(&block)
      self.inject({}) { |h, i|
        h[i[0]] = yield(i[0], i[1])
        h
      }
    end
  
    def extract(*keys)
      keys.inject({}) { |h, key|
        h[key] = self[key] if self.key?(key)
        h
      }
    end
  end
end

Hash.send :include, Slab::HashExt
