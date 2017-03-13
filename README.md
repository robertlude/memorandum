# Memorandum

[![Gem Version](https://badge.fury.io/rb/memorandum.svg)](https://badge.fury.io/rb/memorandum)
[![Build Status](https://travis-ci.org/robertlude/memorandum.svg?branch=master)](https://travis-ci.org/robertlude/memorandum)

## Description

Memorandum provides a simple method to memoize method results. It also provides
flags for freezing the cached results: `freeze` and `deep_freeze`.

## Example

```ruby
require 'memorandum'

class Example
  extend Memorandum

  memo def a_method
    puts "Hello from #a_method!"
    '👓'
  end

  memo def another_method n
    puts "Hello from #another_method(#{n.inspect})"
    (((n + 2) / 3).to_i * 3 * '🐛🐜🐝')[0...n].strip
  end

  memo :deep_freeze, def yet_another_method
    {
      child: {
        name: "Memoranda"
      }
    }
  end
end

example = Example.new

puts example.a_method
puts example.a_method
puts example.another_method 3
puts example.another_method 3
puts example.another_method 5
puts example.another_method 5
```

```
Hello from #a_method!
👓
👓
Hello from #another_method(3)
🐛  🐜  🐝
🐛  🐜  🐝
Hello from #another_method(5)
🐛  🐜  🐝  🐛  🐜
🐛  🐜  🐝  🐛  🐜
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

## Flags

Flags may optionally be used as arguments before the method name:

```ruby
memo :freeze, def my_method
  { data: "my data" }
end
```

| Flag | Description |
| --- | --- |
| `:freeze` | Freezes the result |
| `:deep_freeze` | Freezes the result and all of it's descendants |

## Development

1. Fork this repo
2. `gem install hoe`
3. Navigate to your local copy
4. `rake newb` to setup development
5. Run `rake` to run tests
6. Run `rake check_manifest` to make sure `Manifest.txt` remains up to date

## Packaging

1. Make sure `lib/memorandum/version.rb` is up-to-date
2. `rake gem` to build the gem
3. `rake install_gem` to test locally
4. `rake release_sanity VERSION=x.y.z` to check release sanity
5. `rake release VERSION=x.y.z` to publish
