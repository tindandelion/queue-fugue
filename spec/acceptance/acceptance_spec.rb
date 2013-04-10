require 'instruments'
require 'testable_player'
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
      config = Configuration.new(TestablePlayer)
      config.instance_eval do
        map '*', to: 'BASS_DRUM'
        map 'O', to: 'ACOUSTIC_SNARE'
        map '+', to: 'CRASH_CYMBAL'
      end
      config.create_player
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
      
      config = Configuration.new(TestablePlayer)
      config.apply_external(file_with_contents(config_string))
      player = config.create_player
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
    file = double(:file)
    file.stub(:exist?).and_return(true)
    file.stub(:read).and_return(string)
    file
  end
end

