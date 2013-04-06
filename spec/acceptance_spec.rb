require 'messaging'
require 'application'
require 'async_helper'

class FakeNotePlayer
  attr_reader :rhythm_played
  
  def play_rhythm(rhythm_strings)
    @rhythm_played = rhythm_strings
  end
end

describe "Acceptance tests for Queue Fugue" do
  include AsyncHelper
  
  let(:server_url) { 'tcp://localhost:61616' }
  let(:queue_name) { 'TEST' }
  
  it 'plays background sound' do
    note_player = FakeNotePlayer.new
    app = QueueFugueApp.new(note_player)
    
    app.start(server_url, queue_name)
    begin
      app.play_chunk
      note_player.should played_rhythm(QueueFugueApp::BACKGROUND_RHYTHM)
    ensure
      app.stop!
    end
  end
  
  it 'plays a drum hit when a message arrives' do
    note_player = FakeNotePlayer.new
    app = QueueFugueApp.new(note_player)
    
    app.start(server_url, queue_name)
    begin
      send_message(server_url, queue_name)
      
      app.play_chunk
      note_player.should played_rhythm(QueueFugueApp::DRUM_HIT,
                                       QueueFugueApp::BACKGROUND_RHYTHM)

      app.play_chunk
      note_player.should played_rhythm(QueueFugueApp::BACKGROUND_RHYTHM)
      
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

RSpec::Matchers.define :played_rhythm do |*expected_rhythm|
  match do |player|
    player.rhythm_played == expected_rhythm
  end
  
  failure_message_for_should do |player|
    "expected player to play #{expected_rhythm}, but actually played #{player.rhythm_played}"
  end
end

