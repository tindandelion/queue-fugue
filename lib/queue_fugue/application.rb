require 'queue_fugue/messaging'
require 'queue_fugue/rhythm_synthesizer'

class QueueFugueApp
  def initialize(note_player)
    @note_player = note_player
    @synthesizer = RhythmSynthesizer.new
  end
  
  def start(server_url, queue_name)
    @receiver = MessageReceiver.new(server_url, queue_name)
    @receiver.listen_for_messages { |msg| @synthesizer.message_received(msg.text.size) }
    @playing = true
  end
  
  def play_chunk
    @note_player.play_rhythm @synthesizer.produce_rhythm
  end
  
  def loop
    play_chunk while @playing
  end
  
  def stop!
    @receiver.close!
    @playing = false
  end
end
