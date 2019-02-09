require 'sneakers'
require 'sneakers/handlers/maxretry'

Sneakers.configure(
  handler: Sneakers::Handlers::Maxretry,
  prefetch: 1,
  threads: 1,
  workers: 1,
  heartbeat: 30,
)

Sneakers.logger.level = Logger::INFO

