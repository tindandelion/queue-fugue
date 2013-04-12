require 'queue_fugue/beat_counter'

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
    
    def initialize(default_instrument)
      @default_instrument = default_instrument
      @beat_counts = initial_beat_counts(@default_instrument)
    end
    
    def initial_beat_counts(default_instrument)
      { long_messages: BeatCounter.new('+'),
        normal_messages: BeatCounter.new(default_instrument) }
    end
    
    def message_received(message_size)
      if message_size < LONG_MESSAGE_THRESHOLD
        @beat_counts[:normal_messages].inc
      else
        @beat_counts[:long_messages].inc
      end
    end
    
    def produce_rhythm
      rhythm = @beat_counts.values.inject([]) { |res, bc| res + self.class.calculate_rhythm(bc) }
      
      @beat_counts = initial_beat_counts(@default_instrument)
      
      rhythm + [BACKGROUND_BEAT]
    end
    
    def self.calculate_rhythm(beat_count)
      return [] if beat_count.zero?
      
      beat_position = [beat_count.count - 1, BEAT_PATTERNS.length - 1].min
      pattern = BEAT_PATTERNS[beat_position]
      return [pattern.gsub('_', beat_count.marker)]
    end
  end
end
