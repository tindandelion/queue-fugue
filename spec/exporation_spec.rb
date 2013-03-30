require 'message_sender'

describe "Exploring ActiveMQ interface" do
   it "sends a message to the queue" do
    sender = MessageSender.new('tcp://localhost:61616', "TEST")
    begin 
      sender.send_text_message 'Hello world!'
    ensure
      sender.close!
    end
  end
  
  it 'receives a message from the queue'
end
