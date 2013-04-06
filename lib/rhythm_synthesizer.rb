class RhythmSynthesizer
  BACKGROUND_BEAT = '....*.....**...!'
  
  attr_reader :messages_received
  
  def initialize
    @messages_received = 0
  end
  
  def message_received
    @messages_received += 1
  end
  
  def produce_rhythm
    rhythm = calculate_rhythm
    @messages_received = 0
    rhythm + [BACKGROUND_BEAT]
  end
  
  def calculate_rhythm
    rhythm = []
    case @messages_received
    when 1 then rhythm << '.......O........'
    when 3 then rhythm << '..O....O.....O..'
    end
    rhythm
  end
end
