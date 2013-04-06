require 'messaging'
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
  
  def play_rhythm(rhythm_string)
    @rhythm_string_played = rhythm_string
  end
  
  def has_played_rhythm?(rhythm_strings)
    rhythm_strings == @rhythm_string_played
  end
end

describe "Acceptance tests for Queue Fugue" do
  include AsyncHelper
  
  let(:server_url) { 'tcp://localhost:61616' }
  let(:queue_name) { 'TEST' }
  
  it 'plays a note when a new message arrives' do
    note_player = FakeNotePlayer.new
    app = QueueFugueApp.new(note_player)
    
    app.start(server_url, queue_name)
    begin
      send_message(server_url, queue_name)
      eventually { note_player.should have_played_note }
    ensure
      app.stop!
    end
  end
  
  it 'plays background sound' do
    note_player = FakeNotePlayer.new
    app = QueueFugueApp.new(note_player)
    
    app.start(server_url, queue_name)
    begin
      app.play_chunk
      eventually { note_player.should have_played_rhythm([QueueFugueApp::BACKGROUND_RHYTHM]) }
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
