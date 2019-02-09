class RailsDomainModel::MessageBus
  def initialize
    connect_to_rabbit
  end

  def disconnect
    @connection.close
  end

  # Entry point for RailsEventStore
  def call(event)
    publish([event])
  end

  def publish(events)
    [events].flatten.each do |e|
      exchange.publish(
        RailsDomainModel::EventSerializer.serialize(e),
        persistent: true
      )
    end
  end

  def pop_error_event_for(processor)
    event = nil
    queue_name = processor.queue_name + '-error'
    queue = channel.queue(queue_name, passive: true)
    _, _, message = queue.pop

    return nil unless message

    payload = JSON.parse(message)['payload']
    json = Base64.decode64(payload)
    event = RailsDomainModel::EventSerializer.deserialize(json)
    return processor, event
  end

  def self.pop_first_error_event
    ::Rails.application.eager_load!
    message_bus = self.new
    RailsDomainModel::BaseWorker.descendants.select { |descendant|
      printf "Trying #{descendant}"
      p, e = message_bus.pop_error_event_for(descendant)
      if e
        puts " - Bingo: #{e.class}"
        return p, e if e
      else
        puts ' - Nothing'
      end
    }
  ensure
    message_bus.disconnect
  end

  private

  def connect_to_rabbit
    @channel = nil
    @exchange = nil
    @connection = nil

    exchange
  end

  def connection
    @connection = begin
                    conn = Bunny.new RailsDomainModel.rabbit_producer_url
                    conn.start
                    conn
                  end
  end

  def channel
    @channel ||= connection.create_channel
  end

  def exchange
    @exhange ||= channel.fanout(exhange_name, durable: true)
  end

  def exhange_name
    RailsDomainModel.rabbit_exchange_name
  end

end
