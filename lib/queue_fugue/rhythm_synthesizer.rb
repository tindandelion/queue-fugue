require 'queue_fugue/beat_counter'

module QueueFugue
  class RhythmSynthesizer
    LONG_MESSAGE_THRESHOLD = 50
    BACKGROUND_BEAT = '....*.....**...!'
    
    attr_reader :messages_received
    
    def initialize(default_instrument)
      @default_instrument = default_instrument
      @counters = [BeatCounter.new('+', lambda { |msg| msg.text.size >= LONG_MESSAGE_THRESHOLD }),
                   BeatCounter.new(default_instrument)]
    end
    
    def message_received(message)
      @counters.any? { |c| c.process(message) }
    end
    
    def produce_rhythm
      rhythm = @counters.inject([]) { |res, bc| res + bc.produce_rhythm }
      rhythm + [BACKGROUND_BEAT]
    end
  end
end
