require 'activemq-all-5.8.0.jar'
require 'pry'

describe "Exploring ActiveMQ interface" do
  it "connects to an instance of ActiveMQ" do
    connection_factory = org.apache.activemq.ActiveMQConnectionFactory.new('tcp://localhost:61616')
    connection = connection_factory.create_connection
    
    binding.pry
    
  end
end
