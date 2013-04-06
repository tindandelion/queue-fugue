require 'messaging'
require 'rhythm_synthesizer'

class QueueFugueApp
  BACKGROUND_RHYTHM = '....*.....**...!'
  
  def initialize(note_player)
    @note_player = note_player
    @synthesizer = RhythmSynthesizer.new
  end
  
  def start(server_url, queue_name)
    @receiver = MessageReceiver.new(server_url, queue_name)
    @receiver.listen_for_messages { |msg| @synthesizer.messages_received += 1 }
    @playing = true
  end
  
  def play_chunk
    @note_player.play_rhythm produce_rhythm
  end
  
  def produce_rhythm
    rhythm = []
    case @synthesizer.messages_received
    when 1 then rhythm << '.......O........'
    when 3 then rhythm << '..O....O.....O..'
    end
    @synthesizer.messages_received = 0
    rhythm << BACKGROUND_RHYTHM
    rhythm
  end
  
  def loop
    play_chunk while @playing
  end
  
  def stop!
    @receiver.close!
    @playing = false
  end
end
