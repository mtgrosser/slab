module Kernel
  def returning(value, &block)
    value.tap(&block)
  end
end
