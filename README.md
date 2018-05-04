# AuditedAsync

[![Maintainability](https://api.codeclimate.com/v1/badges/2d4899ab63fcea8a9144/maintainability)](https://codeclimate.com/github/leonardofalk/audited_async/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/2d4899ab63fcea8a9144/test_coverage)](https://codeclimate.com/github/leonardofalk/audited_async/test_coverage)

AuditedAsync is an addon for audited gem which allows to create audits asynchronously using ActiveJob.

It's currently under initial development and I strongly recommend you do not use it in production until it reaches a stable version.

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

All done! Although you can configure some stuff, check below.

#### Enabling it programmatically

```ruby
# config/initializers/audited_async.rb

AuditedAsync.configure do |config|
  config.enabled  = Rails.env.production?
end
```

#### Changing Job execution

```ruby
# config/initializers/audited_async.rb

AuditedAsync.configure do |config|
  config.job_name  = 'JobityJob'
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

To see how the default job performs, [look here](./lib/audited_async/audit_async_job).

## How It Works

AuditedAsync safely inject the `async` option into audited model option using functional programming. If enabled, it'll move audit creation logic into an ActiveJob instance, then it's sent to the queue to be executed later.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/leonardofalk/audited_async>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## To Do

-   [ ] Elaborate more test cases.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
