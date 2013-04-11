require_relative 'activemq-all-5.8.0.jar'

class AmQueueConnector
  include javax.jms.ExceptionListener
  
  def initialize(server_url, queue_name)
    @connection = create_connection(server_url)
    @session = create_session(@connection)
    @queue = @session.create_queue(queue_name)
  end
  
  def close!
    @session.close
    @connection.close
  end
  
  def on_exception(ex)
    raise ex
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
end

class MessageSender < AmQueueConnector
  def initialize(server_url, queue_name)
    super(server_url, queue_name)
    @producer = @session.create_producer(@queue)
  end
  
  def send_text_message(text)
    message = @session.create_text_message(text)
    @producer.send(message)
  end
end

class MessageReceiver < AmQueueConnector
  include javax.jms.MessageListener
  
  def initialize(server_url, queue_name)
    super(server_url, queue_name)
    @connection.start
  end
  
  def listen_for_messages(&block)
    @action = block
    consumer = @session.create_consumer(@queue)
    consumer.message_listener = self
  end
  
  def on_message(message)
    @action.call(message) if @action
  end
end

