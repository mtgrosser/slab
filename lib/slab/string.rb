require 'securerandom'

class String
  def to_iso
    encode('iso-8859-1', :invalid => :replace, :undef => :replace)
  end

  def self.random(length = 12)
    SecureRandom.base64(length)[0..(length - 1)]
  end
end
