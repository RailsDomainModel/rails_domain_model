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

Your first dive into Domain-Driven Design, Event Sourcing and CQRS.

Let's say you're a software developer and that you've built your share of successful Rails apps. You're sitting together with a domain expert who wants you to build some software.

**YOU:** OK, what do you need?

**DOMAIN EXPERT:** I'm writing a lot, and I have these ideas that I want to share with the world. I've heard that the internet is a great place to do that.

**YOU:** I can help you with that.

````bash
$ rails new idea_sharing
$ cd idea_sharing
````

You really want to nail the domain model, so

````Gemfile
# Gemfile

gem 'rails_domain_model'
````

and, as usual,

````bash
$ bundle install
````
   
Before we can dive in with the domain expert, we have a little more plumbing to do.

````
$ spring stop # if you use spring
$ rails generate rails_event_store_active_record:migration
$ rake db:create db:migrate
````

(In case of problems with the above, please refer to the [RailsEventStore documentation](https://railseventstore.org/docs/install/)).

Now you're ready to dive in.

**YOU:** When you usually write, how do you approach that?

**DOMAIN EXPERT:** I sit at my desk and start writing a draft.

**YOU:** OK. Let's see...

You know, that in order for you to provide an interface that supports this situation, you will need some standard Rails infrastructure:

````bash
$ rails generate resource desk/drafts title:string body:text
$ rake db:migrate
````

Now let's create the `new` action:

````ruby
# app/controllers/desk/drafts_controller

class Desk::DraftsController < ApplicationController
  def new
    @draft = Desk::Draft.new
  end
end
````

Now, in the view, let's put this:

````erb
<%# app/views/desk/drafts/new %>

<%= form_for @draft do |f| %>
  <%= f.text_field :title %>
  <%= f.text_area :body %>
<% end %>
````

Up until now, standard Rails stuff. You feel at home, right?

You can show this to your domain expert and get them writing.

**DOMAIN EXPERT:** Well, it's not pretty, but I can definitely get started on my draft here.

*****TIME PASSES*****

**YOU:** So, now you that you've worked on your draft. What do you want to do with it now?

**DOMAIN EXPERT:** Well, I'm not quite ready to show it to anyone yet, but it would be nice if I could store it somewhere. Then I could get back to it later and finish it.

**YOU:** Got it!

````
$ rails generate domain:command desk/store_draft
````

What? This is new! A command? What's that?

Well, a command lives in your domain and uses the ubiquitous language that you and your domain expert agrees upon.

Let's give them a button, and use the command in the controller.

````erb
<%# app/views/desk/drafts/new %>

<%= form_for @draft do |f| %>
  <%= f.text_field :title %>
  <%= f.text_area :body %>
  <%= f.submit 'Store draft' %>
<% end %>
````

````ruby
# app/controllers/desk/drafts_controller

class Desk::DraftsController < ApplicationController
  def create
    Domain::Desk::Commands::StoreDraft.new(
      draft_id: SecureRandom.uuid,
      title: params[:desk_draft][:title],
      body: params[:desk_draft][:body]
    ).execute!
  end
end
````

OK. So now the controller basically just translates HTTP/REST to our domain language? Neat!

Let's look at that command. A command has several responsibilities:

- Define, in the ubiquitous language, how you interact with your domain model.
- Define which aggregate the command applies too, and how.
- Define which attributes are need to do what you want.
- Run validations on those attributes. 

All that looks like this:

````ruby
# domain_model/desk/commands/store_draft.rb

class Domain::Desk::Commands::StoreDraft < DomainCommand
  with_aggregate Domain::Desk::Draft, :draft_id, :store
  
  attr_accessor :title, :body, :draft_id
  
  validates :title, presence: true
end
````

But really, you can make it look, and work exactly how you'd like. Take a look in `domain_model/domain_command.rb` if you, for example, feel like using something particular for defining attributes and doing validations.

But, that `Domain::Desk::Draft` aggregate-thing, what is that?

````bash
$ rails generate domain:aggregate desk/draft
````

Take a look in `domain_model/domain/desk/draft.rb` which we will update to look like this:

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

So, one last thing will be that event we just applied. Let's get that into place:

````bash
$ rails generate domain:event desk/draft_stored
````

That looks like this:

````ruby
# domain_model/domain/desk/events/draft_stored.rb

class Domain::Desk::Events::DraftStored < DomainEvent
end
````

And now, you're done! The draft is stored when you click the button!

Agreed, that was a bit more work than just saving the darn draft in the controller. What did you accomplish here?

Most importantly, you managed to wrangle yourself free from the vocabulary used by your technology stack. (Being HTTP/REST and an SQL database.)

You have established a vocabulary, containing the concepts `desk` , `draft` and `store`, that are completely controlled by your domain expert, and you have to perform zero translation when talking to them.

Also, you are now, officially, event sourcing. 🙌

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anderslemke/rails_domain_model. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RailsDomainModel project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/anderslemke/rails_domain_model/blob/master/CODE_OF_CONDUCT.md).
