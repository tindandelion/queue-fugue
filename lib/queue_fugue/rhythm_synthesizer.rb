require 'queue_fugue/beat_counter'

module QueueFugue
  class RhythmSynthesizer
    LONG_MESSAGE_THRESHOLD = 50
    BACKGROUND_BEAT = '....*.....**...!'
    
    attr_reader :messages_received
    
    def initialize(default_instrument)
      @default_instrument = default_instrument
      @counters = [BeatCounter.new('+'), BeatCounter.new(default_instrument)]
    end
    
    def message_received(message_size)
      select_counter(message_size).inc
    end
    
    def select_counter(message_size)
      if message_size >= LONG_MESSAGE_THRESHOLD
        @counters[0]
      else
        @counters[1]
      end
    end
    
    def produce_rhythm
      rhythm = @counters.inject([]) { |res, bc| res + bc.produce_rhythm }
      rhythm + [BACKGROUND_BEAT]
    end
  end
end
