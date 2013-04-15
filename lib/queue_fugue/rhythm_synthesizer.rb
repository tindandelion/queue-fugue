require 'queue_fugue/beat_counter'

module QueueFugue
  class RhythmSynthesizer
    BACKGROUND_BEAT = '....*.....**...!'
    
    attr_reader :messages_received
    
    def initialize(default_instrument, custom_counters = [])
      @custom_counters = custom_counters
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
