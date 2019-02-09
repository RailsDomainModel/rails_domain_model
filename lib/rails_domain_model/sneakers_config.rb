require 'sneakers/handlers/maxretry'

Sneakers.configure(
  handler: Sneakers::Handlers::Maxretry,
  amqp: RailsDomainModel.rabbit_consumer_url,
  prefetch: 1,
  threads: 1,
  workers: 1,
  heartbeat: 30,
  exchange: RailsDomainModel.rabbit_exchange_name,
  exchange_options: { durable: true, type: :fanout },
)
