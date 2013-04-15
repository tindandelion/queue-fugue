require 'queue_fugue/beat_counter'

module QueueFugue
  class RhythmSynthesizer
    LONG_MESSAGE_THRESHOLD = 50
    BACKGROUND_BEAT = '....*.....**...!'
    
    attr_reader :messages_received
    
    def initialize(default_instrument, counters = nil)
      @custom_counters = if counters
                           counters
                         else
                           [BeatCounter.new('+', lambda { |msg| msg.text.size >= LONG_MESSAGE_THRESHOLD })]
                         end
      @default_counter = BeatCounter.new(default_instrument)
    end
    
    def message_received(message)
      counters.any? { |c| c.process(message) }
    end
    
    def produce_rhythm
      rhythm = counters.inject([]) { |res, bc| res + bc.produce_rhythm }
      rhythm + [BACKGROUND_BEAT]
    end
    
    def counters
      @custom_counters + [@default_counter]
    end
  end
end
