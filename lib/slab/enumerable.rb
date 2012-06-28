module Enumerable
  
  def any_not?(&block)
    not all? { |e| yield(e) }
  end
  
  def none?(&block)
    not any? { |e| yield(e) }
  end
  
  def hmap(&block)
    inject({}) { |hash, obj| hash[obj] = yield(obj); hash }
  end
  
  def hmap_pair(&block)
    inject({}) { |hash, obj| k,v = yield(obj); hash[k] = v; hash }
  end
  alias :build_hash :hmap_pair
  
  def map_with_index
    result = []
    each_with_index do |elt, idx|
      result << yield(elt, idx)
    end
    result
  end
  alias :collect_with_index :map_with_index
  
  def inject_with_index(initial, &block)
    index = 0
    inject(initial) { |memo, obj| result = yield(memo, obj, index); index += 1; result }
  end
  
end