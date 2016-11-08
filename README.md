# Kleisli [![Build Status](https://secure.travis-ci.org/txus/kleisli.png)](http://travis-ci.org/txus/kleisli)

An idiomatic, clean implementation of a few common useful monads in Ruby,
written by [Ryan Levick][rylev] and me.

It aims to be idiomatic Ruby to use in Enter-Prise production apps, not a proof
of concept.

In your Gemfile:

```ruby
gem 'kleisli'
```

We would like to thank Curry and Howard for their correspondence.

## Notation

For all its monads, Kleisli implements `return` (we call it `lift` instead, as
`return` is a reserved keyword in Ruby) with convenience global methods (see
which for each monad below).

Kleisli uses a clever Ruby syntax trick to implement the `bind` operator, which
looks like this: `>->` when used with a block. We will probably burn in hell
for this. You can also use `>` or `>>` if you're going to pass in a proc or
 lambda object.

`Maybe` and `Either` are applicative functors with the apply operator `*`. Read
further to see how it works.

### Function composition

You can use Haskell-like function composition with F and the familiar `.`. This
is such a perversion of Ruby syntax that Matz would probably condemn this:

Think of `F` as the identity function. Although it's just a hack to make it
work in Ruby.

```ruby
# Reminder that (f . g) x= f(g(x))
f = F . first . last
f.call [[1,2], [3,4]]
# => 3

f = F . capitalize . reverse
f.call "hello"
# => "Olleh"
```

Functions and methods are interchangeable:

```ruby
foo = lambda { |s| s.reverse }

f = F . capitalize . fn(&foo)
f.call "hello"
# => "Olleh"
```

All functions and methods are partially applicable:

```ruby

# Partially applied method:
f = F . split(":") . strip
f.call "  localhost:9092     "
# => ["localhost", "9092"]

# Partially applied lambda:
my_split = lambda { |str, *args| str.split(*args) }
f = F . fn(":", &my_split) . strip
f.call "  localhost:9092     "
# => ["localhost", "9092"]
```

Finally, for convenience, `F` is the identity function:

```ruby
F.call(1) # => 1
```

## Maybe monad

The Maybe monad is useful to express a pipeline of computations that might
return nil at any point. `user.address.street` anyone?

### `>->` (bind)

```ruby
require "kleisli"

maybe_user = Maybe(user) >-> user {
  Maybe(user.address) } >-> address {
    Maybe(address.street) }

# If user exists
# => Some("Monad Street")
# If user is nil
# => None()

# You can also use Some and None as type constructors yourself.
x = Some(10)
y = None()

```

As usual (with Maybe and Either), using point-free style is much cleaner:

```ruby
Maybe(user) >> F . fn(&Maybe) . address >> F . fn(&Maybe) . street
```

### `fmap`

```ruby
require "kleisli"

# If we know that a user always has an address with a street
Maybe(user).fmap(&:address).fmap(&:street)

# If the user exists
# => Some("Monad Street")
# If the user is nil
# => None()
```

### `*` (applicative functor's apply)

```ruby
require "kleisli"

add = -> x, y { x + y }
Some(add) * Some(10) * Some(2)
# => Some(12)
Some(add) * None() * Some(2)
# => None
```

### `success?` and `failure?`

```ruby
require "kleisli"

None().success? # => false
Some("Monad Stree").success? # => true
```

## Try

The Try monad is useful to express a pipeline of computations that might throw
an exception at any point.

### `>->` (bind)

```ruby
require "kleisli"

json_string = get_json_from_somewhere

result = Try { JSON.parse(json_string) } >-> json {
  Try { json["dividend"].to_i / json["divisor"].to_i }
}

# If no exception was thrown:

result       # => #<Try::Success @value=123>
result.value # => 123

# If there was a ZeroDivisionError exception for example:

result           # => #<Try::Failure @exception=#<ZeroDivisionError ...>>
result.exception # => #<ZeroDivisionError ...>
```

### `fmap`

```ruby
require "kleisli"

Try { JSON.parse(json_string) }.fmap(&:symbolize_keys).value

# If everything went well:
# => { :my => "json", :with => "symbolized keys" }
# If an exception was thrown:
# => nil
```

### `to_maybe`

Sometimes it's useful to interleave both `Try` and `Maybe`. To convert a `Try`
into a `Maybe` you can use `to_maybe`:

```ruby
require "kleisli"

Try { JSON.parse(json_string) }.fmap(&:symbolize_keys).to_maybe

# If everything went well:
# => Some({ :my => "json", :with => "symbolized keys" })
# If an exception was thrown:
# => None()
```

### `to_either`

Sometimes it's useful to interleave both `Try` and `Either`. To convert a `Try`
into a `Either` you can use `to_either`:

```ruby
require "kleisli"

Try { JSON.parse(json_string) }.fmap(&:symbolize_keys).to_either

# If everything went well:
# => Right({ :my => "json", :with => "symbolized keys" })
# If an exception was thrown:
# => Left(#<JSON::ParserError: 757: unexpected token at 'json'>)
```

### `success?` and `failure?`

```ruby
require "kleisli"

Try { raise 'a failure' }.success? # => false
```

## Either

The Either monad is useful to express a pipeline of computations that might return an error object with some information.

It has two type constructors: `Right` and `Left`. As a useful mnemonic, `Right` is for when everything went "right" and `Left` is used for errors.

Think of it as exceptions without messing with the call stack.

### `>->` (bind)

```ruby
require "kleisli"

result = Right(3) >-> value {
  if value > 1
    Right(value + 3)
  else
    Left("value was less or equal than 1")
  end
} >-> value {
  if value % 2 == 0
    Right(value * 2)
  else
    Left("value was not even")
  end
}

# If everything went well
result # => Right(12)
result.value # => 12

# If it failed in the first block
result # => Left("value was less or equal than 1")
result.value # => "value was less or equal than 1"

# If it failed in the second block
result # => Left("value was not even")
result.value # => "value was not even"

# Point-free style bind!
result = Right(3) >> F . fn(&Right) . *(2)
result # => Right(6)
result.value # => 6
```

### `fmap`

```ruby
require "kleisli"

result = if foo > bar
  Right(10)
else
  Left("wrong")
end.fmap { |x| x * 2 }

# If everything went well
result # => Right(20)
# If it didn't
result # => Left("wrong")
```

### `*` (applicative functor's apply)

```ruby
require "kleisli"

add = -> x, y { x + y }
Right(add) * Right(10) * Right(2)
# => Right(12)
Right(add) * Left("error") * Right(2)
# => Left("error")
```

### `or`

`or` does pretty much what would you expect:

```ruby
require 'kleisli'

Right(10).or(Right(999)) # => Right(10)
Left("error").or(Left("new error")) # => Left("new error")
Left("error").or { |err| Left("new #{err}") } # => Left("new error")
```

### `to_maybe`

Sometimes it's useful to turn an `Either` into a `Maybe`. You can use
`to_maybe` for that:

```ruby
require "kleisli"

result = if foo > bar
  Right(10)
else
  Left("wrong")
end.to_maybe

# If everything went well:
result # => Some(10)
# If it didn't
result # => None()
```

### `success?` and `failure?`

```ruby
require "kleisli"

lefts, rights = [Right(20), Left('10 is too small'), Right(11)].partition(&:failure?)
```

## Future

The Future monad models a pipeline of computations that will happen in the future, as soon as the value needed for each step is available. It is useful to model, for example, a sequential chain of HTTP calls.

There's a catch unfortunately -- values passed to the functions are wrapped in
lambdas, so you need to call `.call` on them. See the examples below.

### `>->` (bind)

```ruby
require "kleisli"

f = Future("myendpoint.com") >-> url {
  Future { HTTP.get(url.call) }
} >-> response {
  Future {
    other_url = JSON.parse(response.call.body)[:other_url]
    HTTP.get(other_url)
  }
} >-> other_response {
  Future { JSON.parse(other_response.call.body) }
}

# Do some other stuff...

f.await # => block until the whole pipeline is realized
# => { "my" => "response body" }
```

### `fmap`

```ruby
require "kleisli"

Future { expensive_operation }.fmap { |x| x * 2 }.await
# => result of expensive_operation * 2
```

## Who's this

This was made by [Josep M. Bach (Txus)](http://blog.txus.io) and [Ryan
Levick][rylev] under the MIT license. We are [@txustice][twitter] and
[@itchyankles][itchyankles] on twitter (where you should probably follow us!).

[twitter]: https://twitter.com/txustice
[itchyankles]: https://twitter.com/itchyankles
[rylev]: https://github.com/rylev
