require 'securerandom'

class String
  def to_iso
    encode('iso-8859-1', :invalid => :replace, :undef => :replace)
  end

  def self.random(length = 12, set = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')
    set_size, string = set.size, ''
    length.times { string << set[SecureRandom.random_number(set_size)] }
    string
  end
end
