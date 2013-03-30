require 'activemq-all-5.8.0.jar'
require 'pry'

describe "Exploring ActiveMQ interface" do

  let(:connection) do
    connection_factory = org.apache.activemq.ActiveMQConnectionFactory.new('tcp://localhost:61616')
    connection_factory.create_connection
  end

  let(:session) { connection.create_session(false, javax.jms.Session::AUTO_ACKNOWLEDGE) }
  
  after :each do
    session.close
    connection.close
  end
  
  it "sends a message to the queue" do
    queue = session.create_queue("TEST")
    producer = session.create_producer(queue)
    producer.set_delivery_mode(javax.jms.DeliveryMode::NON_PERSISTENT)
    
    message = session.create_text_message('Hello world!')
    producer.send(message)
  end
end
