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
  let(:queue_name) { 'ACCEPTANCE_TEST' }
  
  let(:background_beat) { RhythmSynthesizer::BACKGROUND_BEAT }
  
  let(:note_player) { FakeNotePlayer.new }
  let(:app) { QueueFugueApp.new(note_player) }
  
  it 'plays background beat when no activity on the queue' do
    app.start(server_url, queue_name)
    begin
      app.play_chunk
      note_player.should played_rhythm(background_beat)
    ensure
      app.stop!
    end
  end
  
  it 'plays a rhythm which intensity depends on number of messages received' do
    app.start(server_url, queue_name)
    begin
      send_message
      app.play_chunk
      note_player.should played_rhythm('........O.......', background_beat)
      
      3.times { send_message }
      app.play_chunk
      note_player.should played_rhythm('...O....O....O..', background_beat)
      
      app.play_chunk
      note_player.should played_rhythm(background_beat)
    ensure
      app.stop!
    end
  end

  it 'splits messages into different instruments' do
    app.start(server_url, queue_name)
    begin
      3.times { send_message text_with_length(5) }
      send_message text_with_length(100)
      
      app.play_chunk
      note_player.should played_rhythm('........+.......', '...O....O....O..', background_beat)
    ensure
      app.stop!
    end
  end
  
  def send_message(text = '')
    sender = MessageSender.new(server_url, queue_name)
    sender.send_text_message text
  ensure
    sender.close!
  end

  def text_with_length(n)
    '!' * n
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

