require 'rails_event_store'
require 'sneakers'
require 'bunny'
require "rails_domain_model/version"

module RailsDomainModel
  class << self
    attr_writer :rabbit_url, :rabbit_producer_url, :rabbit_consumer_url

    def rabbit_producer_url
      @rabbit_producer_url || rabbit_url
    end

    def rabbit_consumer_url
      @rabbit_consumer_url || rabbit_url
    end

    def rabbit_url
      @rabbit_url || default_rabbit_url
    end

    def default_rabbit_url
      'amqp://guest:guest@localhost:5672'
    end

    def rabbit_exchange_name
      "message_bus"
    end
  end
end

require 'rails_domain_model/generators/command/command_generator'
require 'rails_domain_model/generators/aggregate/aggregate_generator'
require 'rails_domain_model/generators/event/event_generator'
require 'rails_domain_model/command_handler'
require 'rails_domain_model/command'
require 'rails_domain_model/aggregate'
require 'rails_domain_model/event'
require 'rails_domain_model/message_bus'
require 'rails_domain_model/event_serializer'
require 'rails_domain_model/base_worker'
require 'rails_domain_model/sneakers_config.rb'
