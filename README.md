Bencodex
========

A encode/decode library for [bencoding](http://en.wikipedia.org/wiki/Bencode)


Bencode supports four types of objects

  * `string`     - Implemented as an ASCII encoded binary
  * `integer`    - Encoded in base 10 ASCII
  * `list`       - Ordered, heterogenious list
  * `dictionary` - String keys with heterogenious values in lexicographical order

Decode Bencode terms into Elixir terms

```elixir
Bencodex.decode("i1e")        # => 1
Bencodex.decode("3:foo")      # => "foo"
Bencodex.decode("li1e3:fooe") # => [1, "foo"]
Bencodex.decode("d3:fooi1ee") # => %{"foo" => 1}
```

Encode Elixir terms into Bencode terms

The accepted types are integer, binary (string), list and map

```elixir
Bencodex.encode(1)             # => "i1e"
Bencodex.encode("foo")         # => "3:foo"
Bencodex.encode([1, "foo"])    # => "li1e3:fooe"
Bencodex.encode(%{"foo" => 1}) # => "d3:fooi1ee"
```

