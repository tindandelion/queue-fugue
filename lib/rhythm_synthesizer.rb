class RhythmSynthesizer
  LONG_MESSAGE_THRESHOLD = 50
  BACKGROUND_BEAT = '....*.....**...!'
  BEAT_PATTERNS = ['........O.......',
                   '....O.......O...',
                   '...O....O....O..',
                   '..O...O...O...O.',
                   '..O..O..O..O..O.',
                   '.O..O.O.O.O..O..',
                   '.O.O.O.O..O.O.O.',
                   '.O.O.O.O.O.O.O.O',
                   '.O.O.O.OOO.O.O.O',
                   '.O.OOO.O.O.OOO.O',
                   '.O.OOO.OOO.OOO.O',
                   'OO.OOO.OOO.OOO.O',
                   'OO.OOOOOOO.OOO.O',
                   'OO.OOOOOOOOOOO.O',
                   'OO.OOOOOOOOOOOOO',
                   'OOOOOOOOOOOOOOOO']
  
  attr_reader :messages_received
  
  def initialize
    @messages_received = 0
    @long_messages_received = 0
  end
  
  def message_received(message_size)
    if message_size < LONG_MESSAGE_THRESHOLD
      @messages_received += 1
    else
      @long_messages_received += 1
    end
  end
  
  def produce_rhythm
    rhythm = self.class.calculate_rhythm(@long_messages_received, '+') +
      self.class.calculate_rhythm(@messages_received)
    
    @messages_received = 0
    @long_messages_received = 0
    
    rhythm + [BACKGROUND_BEAT]
  end
  
  def self.calculate_rhythm(count, marker = 'O')
    return [] if count.zero?
    
    beat_position = [count - 1, BEAT_PATTERNS.length - 1].min
    pattern = BEAT_PATTERNS[beat_position]
    return [pattern.sub('O', marker)]
  end
end
