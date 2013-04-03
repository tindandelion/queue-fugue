require 'messaging'
require 'async_helper'

describe "Messaging interface" do
  include AsyncHelper
  
  let(:server_url) { 'tcp://localhost:61616' }
  let(:queue_name) { 'TEST' }
  
  it "sends a message to the queue" do
    sender = MessageSender.new(server_url, queue_name)
    begin 
      sender.send_text_message 'Hello world!'
    ensure
      sender.close!
    end
  end
  
  it 'receives a message from the queue' do
    receiver = MessageReceiver.new(server_url, queue_name)
    sender = MessageSender.new(server_url, queue_name)
    begin
      message_received = false
      receiver.listen_for_messages { |msg| message_received = true }
      
      sender.send_text_message 'Hello world!'
      eventually { message_received.should be_true }
    ensure
      receiver.close!
      sender.close!
    end
  end
end


