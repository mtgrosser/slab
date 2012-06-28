class Object
   # The hidden singleton lurks behind everyone
  def metaclass
    class << self; self; end
  end

  def meta_eval(&block)
    metaclass.instance_eval &block
  end
end