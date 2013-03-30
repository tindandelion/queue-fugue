require 'activemq-all-5.8.0.jar'

class MessageSender
  def initialize(server_url, queue_name)
    @connection = create_connection(server_url)
    @session = create_session(@connection)
    @producer = create_producer(@session, queue_name)
  end
  
  def send_text_message(text)
    message = @session.create_text_message('Hello world!')
    @producer.send(message)
  end
  
  def close!
    @session.close
    @connection.close
  end
  
  private
  
  def create_connection(server_url)
    connection_factory = org.apache.activemq.ActiveMQConnectionFactory.new(server_url)
    connection = connection_factory.create_connection
    connection.exception_listener = self
    connection
  end
  
  def create_session(connection)
    connection.create_session(false, javax.jms.Session::AUTO_ACKNOWLEDGE)
  end
  
  def create_producer(session, queue_name)
    queue = session.create_queue(queue_name)
    session.create_producer(queue)
  end
end
