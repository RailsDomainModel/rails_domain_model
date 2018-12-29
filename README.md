## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_domain_model'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_domain_model

## Usage

# Setup

````
$ spring stop # if you use spring
$ rails generate rails_event_store_active_record:migration
$ rake db:create db:migrate
````

# Commands

````
$ rails generate domain:command desk/store_draft
````

````ruby
# domain_model/desk/commands/store_draft.rb

class Domain::Desk::Commands::StoreDraft < DomainCommand
  with_aggregate Domain::Desk::Draft, :draft_id, :store
  
  attr_accessor :title, :body, :draft_id
  
  validates :title, presence: true
end
````
# Aggregates

````bash
$ rails generate domain:aggregate desk/draft
````

````ruby
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
````

# Domain events

````bash
$ rails generate domain:event desk/draft_stored
````

````ruby
# domain_model/domain/desk/events/draft_stored.rb

class Domain::Desk::Events::DraftStored < DomainEvent
end
````

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anderslemke/rails_domain_model. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the RailsDomainModel project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/anderslemke/rails_domain_model/blob/master/CODE_OF_CONDUCT.md).
