require 'queue_fugue/messaging'


module QueueFugue
  class Application
    attr_reader :player
    
    def initialize(player, synthesizer)
      @player = player
      @synthesizer = synthesizer
    end
    
    def start(server_url, queue_name)
      @receiver = MessageReceiver.new(server_url, queue_name)
      @receiver.listen_for_messages { |msg| @synthesizer.message_received(msg) }
      @playing = true
    end
    
    def play_chunk
      @player.play_rhythm @synthesizer.produce_rhythm
    end
    
    def loop
      play_chunk while @playing
    end
    
    def stop!
      @receiver.close!
      @playing = false
    end
  end
end
