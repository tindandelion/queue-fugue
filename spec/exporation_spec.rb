require 'message_sender'

describe "Exploring ActiveMQ interface" do
  SERVER_URL = 'tcp://localhost:61616'
  QUEUE_NAME = 'TEST'
  
  it "sends a message to the queue" do
    sender = MessageSender.new(SERVER_URL, QUEUE_NAME)
    begin 
      sender.send_text_message 'Hello world!'
    ensure
      sender.close!
    end
  end
  
  it 'receives a message from the queue' do
    receiver = MessageReceiver.new(SERVER_URL, QUEUE_NAME)
    sender = MessageSender.new(SERVER_URL, QUEUE_NAME)
    begin
      message_received = false
      receiver.listen_for_messages { |msg| message_received = true }
      
      sender.send_text_message 'Hello world!'
      sleep 0.5 # Wait some reasonable time
      
      message_received.should be_true
    ensure
      receiver.close!
      sender.close!
    end
  end
end

