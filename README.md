# Assume

Assume is a tool that helps you record your assumptions about code directly in the code you're writing. It is similiar in functionality to and directly inspired by [solid_assert](https://rubygems.org/gems/solid_assert).

## What?

We make lots of assumptions when we write code. [Programming with assertions](https://docs.oracle.com/javase/8/docs/technotes/guides/language/assert.html) is a technique that helps you catch problems with your assumptions earlier in the development process.  

Assertions live in a subtle space between testing your code explicitly and
raising exceptions to enforce your api behaviour or handle edge cases. It is not a replacement for either.

This gem is an attempt to make the concept less computer-sciency and more english, encouraging you to think about and record your assumptions as you go, maybe even leave them in the codebase for your colleagues to find, so they may understand your thinking, and thus your code, better.

## Why tho?

You might have found yourself writing something like this:

```ruby
# i is the value of some enum 0-3
if i == 0
  # do something cool
elsif i == 1
  # do something cooler
elsif i == 2
  # do something so cool the sun freezes
else # we know i == 3
  # do something awesome
end
```

We know we don't need to perform another check on i, as we've exhausted all other options, but what happens when 'Dave' comes along next month and extends the enum to allow a 4?

By recording our assumption in code, 'Dave' will (hopefully) test his new enum and quickly discover that he broke our previous assumptions.

If he happens to read our code, it will say *right there in the code* that he's broken it, and he'll know to fix it.

```ruby
# i is now the value of some enum 0-4
if i == 0
  # do something cool
elsif i == 1
  # do something cooler
elsif i == 2
  # do something so cool the sun freezes
else
  assume { i == 3 } # BadAssumption!
end
```

If you had written this only as a comment, 'Dave' might've merged a bug because he had no idea this code even existed.
And if you *didn't even write a comment*, 'Dave' might not have noticed, even if he read your code. (Although in this example he probably would)

## More examples

You're writing a method and assuming it gets called after a certain point. You're actually assuming that there is a certain state available to you.

```ruby
class ThingDoer
  # ...

  private def do_the_thing
    assume { @thingies.size > 0 }
  end

  # ...
end
```

You're doing some control flow you know will never happen

```ruby
  def something(arg)
    case arg
    when 1
    when 2
    when 3
    else
      # instead of raise "this should never happen"
      assume { false } # maybe real users don't need to notice, since this is not actually dangerous
    end
  end
```

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

assume { "yes" == "no" } # NoMethodError!
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

# it is common only to run assertions in development/test environments
# prod users get to be blissfully unaware, and the application does less work in prod
# Assume.enabled = Whatever.env != "prod"
Assume.enabled = true

assume { "yes" == "no" } # Assume::BadAssumption!

Assume.handler = proc { |result, block|
  $stderr.puts "oh noes"
}

assume { true } # => nil
assumption { false } # => nil, (on stderr) => "oh noes\n"
assert { true } # NoMethodError!

alias assert assume # (if you're old-school like that)

assert { true } # => nil 
```

## Don'ts

Don't use assume and rescue BadAssumption as an error handling mechanism.
Make your own error class and `raise`/`rescue` it.  
Don't use assume to enforce the public api of a class/method. `raise ArgumentError` instead.  

You should probably not use assume directly in a test case (you've already got expect/assert/whatever) but if the code under test uses assume and assume is enabled in your test suite, bonus! Your test suite is now more robust!

## Advanced

This gem has been developed on ruby 2.6.5 and 2.7.2, but it should work on basically all versions. If it doesn't work for whatever reason, it is probably due to the default broken assumption handler. Consider replacing it with something simpler:

```ruby
Assume.handler = proc { |result, block|
  raise ::Assume::BadAssumption
}
```

Or using Proc#to_source from [sourcify](https://github.com/jhellerstein/sourcify)

```ruby
Assume.handler = proc { |result, block|
  raise ::Assume::BadAssumption, "failed assumption:\n\n#{block.to_source}\n"
}
```

etc...

The default handler will only print the first line of source code which
the block's #source_location method points it at. E.g. it will not print any source code in irb, for example.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Warning: Do not use `rspec` to run all the tests, they will fail as they are testing require statements. Use `rake`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/odinhb/assume.
