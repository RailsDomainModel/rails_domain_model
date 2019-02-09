class EventProcesssors::ApplicationProcessor
  include Sneakers::Worker

  private

  # Sneakers config
  def self.queue_opts
    {
      durable: true,
      ack: true,
      prefetch: prefetch_count,
      timeout_job_after: message_timeout,
      retry_timeout: 5000,
      heartbeat: 30,
      arguments: {
        :'x-dead-letter-exchange' => "#{queue_name}-retry"
      }
    }
  end

  def queue_name
  end
end

