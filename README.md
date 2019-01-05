## Goal

Make Bounded Contexts, Event Sourcing and CQRS available in a "convention over configuation"-way.

## Why?

### Ubiquitous Language

All the concepts and building blocks in RailsDomainModel will help you implement your business' Ubiquitous Language.

It allows you to break free of the vocabulary used in controllers and models of Ruby On Rails. Those vocabularies are tied to HTTP/REST and databases respectively and you want to use the vocabulary used by your business. I.e. the Ubiquitous Language.

### Decomposition

Which will give you scalability both regarding performance and complexity.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_domain_model'
```

And then execute:

    $ bundle

To get `RailsEventStore` going:

```
$ spring stop # if you use spring
$ rails generate rails_event_store_active_record:migration
$ rake db:create db:migrate
```

## Dependencies

- [Rails Event Store](https://railseventstore.org)
- [RabbitMQ](https://www.rabbitmq.com/download.html)
- [Sneakers](http://jondot.github.io/sneakers/)
- [Redis](https://redis.io)

## Concepts

The core concepts in RailsDomainModel is

- [Bounded Contexts](#bounded_context)
- [Domain events](#domain_event)
- [Commands](#commands)
- [Aggregates](#aggregates)
- [Event Processors](#event_processors)

### Bounded Contexts

To help you establish a Ubiquitous Language, RailsDomainModel assumes your domain is divided into Bounded Contexts.

If this concept is new to you, please familiarize yourself with it, before going any further.

The canonical source of Bounded Context is Eric Evans book Domain-Driven Design.

Martin Fowler has a short introduction in his article [BoundedContext](https://martinfowler.com/bliki/BoundedContext.html).

In RailsDomainModel a Bounded Contexts are just modules that are used to namespace everything else. So all the following concepts relate to a Bounded Context some way or another.

### Domain events

A domain event encapsulates that something happened that somebody cares about.

```bash
$ rails generate domain:event desk/draft_stored
```

```ruby
# domain_model/domain/desk/events/draft_stored.rb

class Domain::Desk::Events::DraftStored < DomainEvent
end
```

### Aggregates

An aggregate is an object, whose current state is the sum (aggregate) of all it's associated domain events. 

The current state is calculated by _applying_ all historic events.

```bash
$ rails generate domain:aggregate desk/draft
```

```ruby
# domain_model/domain/desk/draft.rb

class Domain::Desk::Draft < DomainAggregate

  def store(command)
    _apply Domain::Desk::Events::DraftStored.new( data: {
      draft_id: command.draft_id,
      title: command.title,
      body: command.body
    } )
  end
  
  private
  
  def apply_draft_stored(event)
  end
  
end
```

### Commands

A command captures the semantics of an intention to change state.

It defines what has to be present when wanting to alter the state in a specific way.

```
$ rails generate domain:command desk/store_draft
```

```ruby
# domain_model/desk/commands/store_draft.rb

class Domain::Desk::Commands::StoreDraft < DomainCommand
  attr_accessor :body, :draft_id

  alias_method :aggregate_id, :draft_id

  with_aggregate Domain::Desk::Draft, call: :store
end
```

### Event Processors

WIP

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anderslemke/rails_domain_model. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the RailsDomainModel project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/anderslemke/rails_domain_model/blob/master/CODE_OF_CONDUCT.md).
