# http://extensions.rubyforge.org/rdoc/classes/Module.html

class Module
  def basename
    self.name.sub(/^.*::/, '')
  end
end