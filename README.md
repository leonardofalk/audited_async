# AuditedAsync

[![CircleCI](https://circleci.com/gh/leonardofalk/audited_async.svg?style=svg)](https://circleci.com/gh/leonardofalk/audited_async)

AuditedAsync is an extension for the [audited](https://github.com/collectiveidea/audited) gem which allows to create audits asynchronously using ActiveJob.

It works by safely injecting the `async` option into audited model option using functional programming. If enabled, it'll move audit creation logic into an ActiveJob instance, then it's sent to the queue to be executed later.

## Installation

Add this line to your application's Gemfile, right after audited gem:

```ruby
gem 'audited'
gem 'audited_async'
```

And then execute:

    $ bundle

## Usage

```ruby
class Post < ApplicationRecord
  audited async: true
end
```

Depending on your active job adapter, you may need to make the queue name visible to the adapter.

### Sidekiq

```yaml
# config/sidekiq.yml
...
:queues:
  - [audits, 1] # add this line
```

All done! Although you can optionally configure some more stuff, check below.

#### Enabling it programmatically

```ruby
# config/initializers/audited_async.rb

AuditedAsync.configure do |config|
  config.enabled = Rails.env.production?
end
```

#### Changing Job execution

```ruby
# config/initializers/audited_async.rb

AuditedAsync.configure do |config|
  config.job_name  = 'JobityJob'
  config.job_options = { wait: 1.second }
end
```

Create your own job:

```ruby
class JobityJob < ApplicationJob
  queue_as :audits

  def perform(audit_info)
    # audit_info = {
    #   class_name:      'Post',
    #   record_id:       2,
    #   audited_changes: "{\"json_stringified_changes\": \"with_values\"}",
    #   action:          one of %w[create update destroy],
    #   comment:         there will be some string here if audited comments are enabled,
    # }

    # ...
    # run your logic
    # ...

    # job must have this line at the end
    class_name.constantize.send(:write_audit, attributes)
    # attributes = {
    #   audited_changes: {hash_changes: :with_values},
    #   action:          one of %w[create update destroy],
    #   comment:         comment, if enabled
    # }
  end
end
```

### Limitations

 - Audits for destroying an object are subject to soft delete, hard deleted records are ignored, so if you are using some library like [paranoia](https://github.com/rubysherpas/paranoia) or [discard](https://github.com/jhawthorn/discard), destroying an object will still create audits, regardless model scoping.
 - Attributes passed down to job are limited to serializable attributes, you can find a [list here](https://edgeguides.rubyonrails.org/active_job_basics.html#supported-types-for-arguments), other than that would throw an error.

To see how the default job performs, [look here](./lib/audited_async/audit_async_job.rb).

## Sample App

https://github.com/leonardofalk/audited_async_sample.git

## Development

Check out the repository, execute `bundle install` and you're good to go.

## Testing

There are some unit tests now but integration tests are missing. You can ran the suite by executing `rspec`.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/leonardofalk/audited_async>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## To Do

-   [ ] Elaborate integration test cases.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
