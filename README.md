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
