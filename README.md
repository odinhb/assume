# Assume

Assume is a gem that helps you record your assumptions about code directly in the code you're writing

## But why?

You make lots of assumptions while writing code. Some are dangerous, others would just be nice if someone (the runtime) double-checked from time to time...

Maybe you never woulda pushed that change that took down the whole system?
Maybe you would know wtf your coworker was thinking when he wrote that function, if he had written his assumptions down?

How about you write those down for your colleagues and fellow programmers who come after you?
Or just for your code to trip on while developing, so you know if something breaks when you're moving that code around.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "assume"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install assume

## Setup

This:

```ruby
require "assume"

assume { "this" } # NoMethodError!
assumption { "gravity still works" } # NoMethodError!
```
Does not allow you to use the methods alone. You have three options:

```ruby
require "assume/core_ext" # monkey-patches Object to provide the methods everywhere
```

```ruby
require "assume/refine" # Loads Assumptions

class Whatever
  using Assumptions # assume's methods are now available in this class

  # ...

  def do_the_thing
    assume { @true == false }

    @true = true
    # ...
  end
end
```

or you can just do it yourself:

```ruby
include Assume

# or

class Whatever
  include Assume
end

# etc...
```

## Usage

```ruby
require "assume"
require "assume/core_ext"

# assume does nothing by default
assume { true == false } # => nil

# we only want assume to run our assumptions in dev/test/ci/staging etc etc
# prod users get to be blissfully unaware
if Whatever::Environment != "prod"
  Assume.enable!
end

assume { "yes" == "no" } # Assume::BrokenAssumption!

handle_broken_assumptions do |result, block|
  $stderr.puts "oh noes"
end

assume { true } # => nil
assumption { false } # => nil, (on stderr) => "oh noes"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Do not use `rspec` to run all the tests, they will fail as they are testing require statements

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/assume.
