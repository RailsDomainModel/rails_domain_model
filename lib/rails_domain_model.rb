require 'rails_event_store'
require "rails_domain_model/version"

module RailsDomainModel
end

require 'rails_domain_model/generators/command/command_generator'
require 'rails_domain_model/generators/aggregate/aggregate_generator'
require 'rails_domain_model/generators/event/event_generator'
require 'rails_domain_model/command_handler'
require 'rails_domain_model/command'
require 'rails_domain_model/aggregate'
require 'rails_domain_model/event'
