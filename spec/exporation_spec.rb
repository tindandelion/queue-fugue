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
  
  it 'receives a message from the queue' do
    connection, session = connect_to_queue
    begin
      connection.exception_listener = self
      listener = listen_for_messages(session)
      connection.start
      
      send_message
      sleep 0.5
      listener.should have_received_message
    ensure
      session.close
      connection.close
    end
  end
  
  def connect_to_queue
    connection = AmqHelper.create_connection('tcp://localhost:61616')
    session = AmqHelper.create_session(connection)
    [connection, session]
  end
  
  def listen_for_messages(session)
    queue = session.create_queue('TEST')
    consumer = session.create_consumer(queue)
    listener = MyMessageListener.new
    consumer.message_listener = listener
    listener
  end
  
  def send_message
    sender = MessageSender.new('tcp://localhost:61616', "TEST")
    begin 
      sender.send_text_message 'Hello world!'
    ensure
      sender.close!
    end
  end
end

class MyMessageListener
  include javax.jms.MessageListener

  def initialize
    @message_received = false
  end
  
  def on_message(message)
    @message_received = true
  end

  def has_received_message?
    @message_received
  end
end
