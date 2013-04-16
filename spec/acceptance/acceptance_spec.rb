require 'queue_fugue'
require 'testable_player'
require 'async_helper'


describe "Acceptance tests for Queue Fugue" do
  include AsyncHelper
  
  let(:server_url) { 'tcp://localhost:61616' }
  let(:queue_name) { 'ACCEPTANCE_TEST' }
  
  context 'playing music' do
    
    it 'plays background beat when no activity on the queue' do
      app = create_application do
        instruments { map '*', to: 'BASS_DRUM' }
      end
      player = app.player
      
      app.start(server_url, queue_name)
      begin
        app.play_chunk
        player.should played_beats('BASS_DRUM', 3) # Background beat is implicitly set to '....*.....**...!'
      ensure
        app.stop!
      end
    end
    
    it 'plays a default instrument beat when a message is received' do
      app = create_application do
        play_default 'MARACAS'
      end
      player = app.player
      
      app.start(server_url, queue_name)
      begin
        send_message
        app.play_chunk
        player.should played_beats('MARACAS', 1)
      ensure
        app.stop!
      end
    end
    
    it 'plays a rhythm which intensity depends on number of messages received' do
      app = create_application do
        play_default 'MARACAS'
      end
      player = app.player
      
      app.start(server_url, queue_name)
      begin
        send_message
        app.play_chunk
        player.should played_beats('MARACAS', 1)
        
        3.times { send_message }
        app.play_chunk
        player.should played_beats('MARACAS', 3)
        
        app.play_chunk
        player.should played_beats('MARACAS', 0)
      ensure
        app.stop!
      end
    end
    
    it 'splits messages into different instruments according to configured rules' do
      long_message_size = 20
      
      app = create_application do
        play_default 'MARACAS'
        
        instruments do
          map '+', to: 'BANJO'
        end
        
        rhythms do
          play '+', when: ->(msg) { msg.text.length > long_message_size }
        end
      end
      
      player = app.player
      
      app.start(server_url, queue_name)
      begin
        3.times { send_message text_with_length(long_message_size - 1) }
        send_message text_with_length(long_message_size + 1)
        
        app.play_chunk
        player.should played_beats('MARACAS', 3)
        player.should played_beats('BANJO', 1)
      ensure
        app.stop!
      end
    end
  end
  
  context 'configured externally' do
    it 'reads configuration from the external file' do
      config_string = <<-EOF
                       play_default 'BANJO'
                      EOF
      
      app = create_application(file_with_contents(config_string))
      
      player = app.player
      
      app.start(server_url, queue_name)
      begin
        send_message
        app.play_chunk
        player.should played_beats('BANJO', 1)
      ensure
        app.stop!
      end
    end
  end
  
  def create_application(config_file = nil, &block)
    QueueFugue.create_application(TestablePlayer, config_file, &block)
  end
  
  def send_message(text = '')
    sender = QueueFugue::MessageSender.new(server_url, queue_name)
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

