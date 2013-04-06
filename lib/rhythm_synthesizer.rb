class RhythmSynthesizer
  attr_reader :messages_received
  
  def initialize
    @messages_received = 0
  end
  
  def message_received
    @messages_received += 1
  end
  
  def reset
    @messages_received = 0
  end
end
