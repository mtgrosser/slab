class BigDecimal
  
  def inspect
    "#<BigDecimal:#{object_id.to_s(0x10)}@#{precs.first},#{precs.last}  #{to_s}>"
  end
  
end