class RhythmSynthesizer
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
    return [] if @messages_received.zero?
    return [BEAT_PATTERNS[min(@messages_received - 1, BEAT_PATTERNS.length - 1)]]
  end
  
  def min(*nums)
    nums.min
  end
end
