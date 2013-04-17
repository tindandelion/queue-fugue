require 'queue_fugue/messaging'


module QueueFugue
  class Application
    attr_reader :player
    
    def initialize(player, beat_counters, background_beat)
      @player = player
      @beat_counters = beat_counters
      @background_beat = background_beat
    end
    
    def start(server_url, queue_name)
      @receiver = MessageReceiver.new(server_url, queue_name)
      @receiver.listen_for_messages { |msg| process_message(msg) }
      @playing = true
    end
    
    def play_chunk
      @player.play_rhythm produce_rhythm
    end
    
    def loop
      play_chunk while @playing
    end
    
    def stop!
      @receiver.close!
      @playing = false
    end
    
    private
    
    def process_message(msg)
      @beat_counters.any? { |bc| bc.process(msg) }
    end
    
    def produce_rhythm
      rhythm = @beat_counters.inject([]) { |res, bc| res + bc.produce_rhythm }
      rhythm + [@background_beat]
    end
  end
end
