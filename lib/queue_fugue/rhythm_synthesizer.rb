module QueueFugue
  class RhythmSynthesizer
    
    BACKGROUND_BEAT = '....*.....**...!'
    
    def initialize(counters)
      @counters = counters
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
