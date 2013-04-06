require 'messaging'

class QueueFugueApp
  DRUM_HIT          = '.......O........'
  BACKGROUND_RHYTHM = '....*.....**...!'
  
  def initialize(note_player)
    @note_player = note_player
  end
  
  def start(server_url, queue_name)
    @receiver = MessageReceiver.new(server_url, queue_name)
    @receiver.listen_for_messages { |msg| @message_received = true }
    @playing = true
  end
  
  def play_chunk
    rhythm = []
    if @message_received
      rhythm << DRUM_HIT
      @message_received = false
    end
    rhythm << BACKGROUND_RHYTHM
    @note_player.play_rhythm rhythm
  end
  
  def loop
    play_chunk while @playing
  end
  
  def stop!
    @receiver.close!
    @playing = false
  end
end
