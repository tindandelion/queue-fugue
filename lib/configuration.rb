class Configuration
  def self.read(io)
    self.new
  end
  
  def instruments
    Instruments.new
  end
end
