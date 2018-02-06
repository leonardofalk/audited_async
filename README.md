# AuditedAsync

AuditedAsync is an addon for audited gem which allows to create audits asynchronously using ActiveJob.

It's currently under initial development and I strongly recommend you do not use it in production until it reaches a stable version.

## Installation

Add this line to your application's Gemfile, right after audited gem:

```ruby
gem 'audited'
gem 'audited_async', '~> 0.1.2'
```

And then execute:

    $ bundle

## Usage

All done!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leonardofalk/audited_async. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## To Do

- [ ] Avoid overriding audited methods.
- [ ] Prepare the Gem to be configurable.
- [ ] Elaborate test cases.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
