module QueueFugue
  class RhythmSynthesizer
    LONG_MESSAGE_THRESHOLD = 50
    BACKGROUND_BEAT = '....*.....**...!'
    BEAT_PATTERNS = ['........_.......',
                     '...._......._...',
                     '..._...._...._..',
                     '.._..._..._..._.',
                     '.._.._.._.._.._.',
                     '._.._._._._.._..',
                     '._._._._.._._._.',
                     '._._._._._._._._',
                     '._._._.___._._._',
                     '._.___._._.___._',
                     '._.___.___.___._',
                     '__.___.___.___._',
                     '__._______.___._',
                     '__.___________._',
                     '__._____________',
                     '________________']
    
    attr_reader :messages_received
    attr_accessor :default_instrument
    
    def initialize
      @default_instrument = 'O'
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
        self.class.calculate_rhythm(@messages_received, @default_instrument)
      
      @messages_received = 0
      @long_messages_received = 0
      
      rhythm + [BACKGROUND_BEAT]
    end
    
    def self.calculate_rhythm(count, marker)
      return [] if count.zero?
      
      beat_position = [count - 1, BEAT_PATTERNS.length - 1].min
      pattern = BEAT_PATTERNS[beat_position]
      return [pattern.gsub('_', marker)]
    end
  end
end
