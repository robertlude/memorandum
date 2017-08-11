# Memorandum

[![Build Status](https://travis-ci.org/robertlude/memorandum.svg?branch=master)](https://travis-ci.org/robertlude/memorandum)

`Memorandum` provides a simple method to memoize method results. It also
provides flags for freezing the cached results: `freeze` and `deep_freeze`.

```ruby
require 'memorandum'

class Example
  extend Memorandum

  memo def a_method
    puts "Hello from #a_method!"

    rand 'a'..'z'
  end

  memo def another_method n
    puts "Hello from #another_method(#{n.inspect})"

    Array.new(n) { ('a'..'z').to_a.sample }.join
  end

  memo :deep_freeze, def yet_another_method
    {
      child: {
        name: "Memoranda"
      }
    }
  end

  def reset_everything
    memorandum_reset :a_method
    memorandum_reset :another_method
  end
end

example = Example.new

puts example.a_method
puts example.a_method
puts example.another_method 3
puts example.another_method 3
puts example.another_method 5
puts example.another_method 5

example.reset_everything

puts example.a_method
puts example.another_method 3
puts example.another_method 3
```

```
Hello from #a_method!
r
r
Hello from #another_method(3)
melg
melg
Hello from #another_method(5)
tmsic
tmsic
x
biel
udihe
```

## Usage

### Ruby >= 2.1

```ruby
memo def the_method arg, another_arg
  'Hello, world'
end
```

### Ruby < 2.1

```ruby
def the_method
  'Hello, world'
end
memo :the_method
```

### Resetting a Cache

You can reset a method's cached data with `#memorandum_reset`

```ruby
class ResetExample
  extend Memorandum

  memo def example_method
    rand
  end

  def reset_some_things
    memorandum_reset :example_method
  end
end
```

## Flags

Flags may optionally be used as arguments before the method name:

```ruby
memo :freeze, def my_method
  { data: "my data" }
end
```

| Flag           | Description                                    |
| -------------- | ---------------------------------------------- |
| `:freeze`      | Freezes the result                             |
| `:deep_freeze` | Freezes the result and all of it's descendants |

## Changes

### v2.2

* Add `#memorandum_reset` method

### v2.1

* Add `:freeze` and `:deep_freeze` flags

### v2.0

* New interface

### v1.1

* Fix context bug

### v1.0

* Initial release
