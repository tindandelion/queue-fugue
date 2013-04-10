require 'instruments'
require 'jfugue_note_player'
require 'configuration'
require 'messaging'
require 'application'
require 'async_helper'

describe "Acceptance tests for Queue Fugue" do
  include AsyncHelper
  
  let(:server_url) { 'tcp://localhost:61616' }
  let(:queue_name) { 'ACCEPTANCE_TEST' }
  
  context 'with pre-configured instruments' do
    let(:player) {
      instruments = Instruments.new
      instruments.add_mapping '*', 'BASS_DRUM'
      instruments.add_mapping 'O', 'ACOUSTIC_SNARE'
      instruments.add_mapping '+', 'CRASH_CYMBAL'
      instruments
      TestablePlayer.new(instruments)
    }
    let(:app) { QueueFugueApp.new(player) }
    
    it 'plays background beat when no activity on the queue' do
      app.start(server_url, queue_name)
      begin
        app.play_chunk
        player.should played_beats('BASS_DRUM', 3) # Background beat is implicitly set to '....*.....**...!'
      ensure
        app.stop!
      end
    end
    
    it 'plays a rhythm which intensity depends on number of messages received' do
      app.start(server_url, queue_name)
      begin
        send_message
        app.play_chunk
        player.should played_beats('ACOUSTIC_SNARE', 1)
        
        3.times { send_message }
        app.play_chunk
        player.should played_beats('ACOUSTIC_SNARE', 3)
        
        app.play_chunk
        player.should played_beats('ACOUSTIC_SNARE', 0)
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
        player.should played_beats('ACOUSTIC_SNARE', 3)
        player.should played_beats('CRASH_CYMBAL', 1)
      ensure
        app.stop!
      end
    end
  end
  
  context 'with external configuration' do
    it 'reads configuration from the external file' do
      config_string = <<-EOF
instruments do
  map 'O', to: 'ACOUSTIC_SNARE' 
end
EOF
      config = Configuration.read(file_with_contents(config_string))
      player = TestablePlayer.new(config.instruments)
      app = QueueFugueApp.new(player)
      
      app.start(server_url, queue_name)
      begin
        send_message
        app.play_chunk
        player.should played_beats('ACOUSTIC_SNARE', 1)
      ensure
        app.stop!
      end
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

  def file_with_contents(string)
    double(:file).stub(:read).and_return(string)
  end
end

class TestablePlayer < JFugueNotePlayer
  attr_reader :music_string
  
  def play(pattern)
    @music_string = pattern.music_string
  end
  
  protected
  
  def with_player(&block)
    block.call(self)
  end
end

RSpec::Matchers.define :played_beats do |instrument, count|
  match do |player|
    beats_played = player.music_string.scan(instrument)
    beats_played.size == count
  end
  
  failure_message_for_should do |player|
    "expected player to play [#{instrument}] #{count} time(s),\n" +
      "but it actually played [#{player.music_string}]"
  end
end
