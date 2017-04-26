# SpamFilterTest

```
spam_filter_test|master⚡ ⇒ iex -S mix
Erlang/OTP 18 [erts-7.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

Set size: 100
strstr:  Range:  2667 -  7087 µs        Median:  2804 µs        Average:  3243 µs
regexp:  Range:  3784 -  6695 µs        Median:  4027 µs        Average:  4389 µs
 re2:    Range:    24 -   475 µs        Median:    46 µs        Average:    52 µs
trie:    Range:   189 -   424 µs        Median:   222 µs        Average:   275 µs
ahoc:    Range:  2545 -  5854 µs        Median:  3174 µs        Average:  3436 µs
juis:    Range:  2437 -  6118 µs        Median:  2535 µs        Average:  2837 µs
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `spam_filter_test` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:spam_filter_test, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/spam_filter_test](https://hexdocs.pm/spam_filter_test).

