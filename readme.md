# Memorandum

`Memorandum` provides a simple method to memoize method results

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
