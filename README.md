# SpamFilterTest

```
spam_filter_test|master ⇒ iex -S mix
Erlang/OTP 18 [erts-7.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.4.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> :trie_vs_re_benchmark.benchmark
Set size: 100
strstr:  Range:  2483 -  4982 µs        Median:  2670 µs        Average:  2898 µs
regexp:  Range:  3544 -  8684 µs        Median:  4038 µs        Average:  4351 µs
trie:    Range:   182 -   377 µs        Median:   196 µs        Average:   202 µs
ahoc:    Range:  2821 -  7163 µs        Median:  3140 µs        Average:  3493 µs
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

