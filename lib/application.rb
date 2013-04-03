require 'message_operators'

class QueueFugueApp
  def initialize(note_player)
    @note_player = note_player
  end
  
  def start(server_url, queue_name)
    @receiver = MessageReceiver.new(server_url, queue_name)
    @receiver.listen_for_messages { |msg| @note_player.play_note }
  end
  
  def stop!
    @receiver.close!
  end
end
