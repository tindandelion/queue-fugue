require 'message_operators'
require 'application'
require 'async_helper'

class FakeNotePlayer
  def initialize
    @has_played_note = false
  end
  
  def play_note
    @has_played_note = true
  end
  
  def has_played_note?
    @has_played_note
  end
end

describe "Acceptance tests for Queue Fugue" do
  include AsyncHelper
  
  SERVER_URL = 'tcp://localhost:61616'
  QUEUE_NAME = 'TEST'
  
  it 'plays a note when a new message arrives' do
    note_player = FakeNotePlayer.new
    app = QueueFugueApp.new(note_player)
    
    app.start(SERVER_URL, QUEUE_NAME)
    begin
      send_message(SERVER_URL, QUEUE_NAME)
      eventually { note_player.should have_played_note }
    ensure
      app.stop!
    end
  end
  
  def send_message(server_url, queue_name)
    sender = MessageSender.new(server_url, queue_name)
    sender.send_text_message ''
  ensure
    sender.close!
  end
end
