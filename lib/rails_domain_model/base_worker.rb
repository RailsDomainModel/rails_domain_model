class RailsDomainModel::BaseWorker
  include Sneakers::Worker

  RetryError = Class.new(StandardError)

  def work(msg)
    event = RailsDomainModel::EventSerializer.deserialize(msg)

    ActiveRecord::Base.connection_pool.with_connection do
      call(event) if event
    end

    return ack!

  rescue RetryError

    return reject!

  end

  def self.handle(message)
    self.new.call(message)
  end

  # Sneakers config
  def self.queue_opts
    {
      durable: true,
      ack: true,
      prefetch: prefetch_count,
      timeout_job_after: message_timeout,
      retry_timeout: 5000,
      heartbeat: 30,
      exchange: RailsDomainModel.rabbit_exchange_name,
      exchange_options: { durable: true, type: :fanout },
      arguments: {
        :'x-dead-letter-exchange' => "#{queue_name}-retry"
      }
    }
  end

  def self.prefetch_count
    1
  end

  def self.message_timeout
    30
  end

  # Sneakers queue name
  def self.queue_name
    word = to_s.dup
    word.gsub!(/::/, '.')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!('-', '_')
    word.downcase!
    word
  end
end
