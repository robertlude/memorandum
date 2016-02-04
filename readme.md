# Memorandum

`Memorandum` provides a simple method to define memoized values.

## Simple Example

```ruby
class SimpleExample
  extend Memorandum

  memo :hello do
    puts 'Block for `#hello` memoizer called!'
    "Hello!"
  end
end

example = SimpleExample.new

puts example.hello
puts example.hello
```

Result:

```
Block for `#hello` memoizer called!
Hello!
Hello!
```

## Example with Arguments

```ruby
class ExampleWithArguments
  extend Memorandum

  memo :multiply do |a, b|
    puts "Block for `#multiply` memoizer called with (#{a}, #{b})!"
    a * b
  end
end

example = ExampleWithArguments.new

puts example.multiply 2, 3
puts example.multiply 2, 3
puts example.multiply 4, 5
puts example.multiply 4, 5
```

Result:

```
Block for `#multiply` memoizer called with (2, 3)!
6
6
Block for `#multiply` memoizer called with (4, 5)!
20
20
```
