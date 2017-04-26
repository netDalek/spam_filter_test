-module(benchmark).

%% API
-export([
    run/0,
    find_strstr/2,
    find_trie/2,
    find_re/2,
    find_ah/2,
    find_jtrie/2,
    find_re2/2,
    run_n_times/4
]).

run() ->
    test_with_set_size(100),
    test_with_set_size(200),
    test_with_set_size(300),
    test_with_set_size(400),
    test_with_set_size(500),
    test_with_set_size(600),
    test_with_set_size(700),
    test_with_set_size(800),
    test_with_set_size(900),
    test_with_set_size(1000).


test_with_set_size(Size) ->
    Message = "pokupka. karta 8193. summa 100.40 rub. ip kamenskaya i.e., ulyanovsk. 01.02.2017 11:36. dostupno 10500.00 rub. tinkoff.ru. кан_набис. покупка. карта 0109.",
    io:format("Set size: ~p~n", [Size]),

    StopWords = readlines("unallowed_word_parts_shuffle.csv", Size),
    Re = string:join(lists:sort([escape_word_for_re(Word) || Word <- StopWords]), "|"),
    {ok, CompiledRe} = re:compile(Re, [unicode]),
    {ok, CompiledRe2} = re2:compile(unicode:characters_to_binary(Re)),
    Trie = trie:new(StopWords),
    Ah = ahocorasick:build_dicts([unicode:characters_to_binary(W) || W <- StopWords]),
    JTrie = lists:foldl(fun juise_trie:add_leaf/2, juise_trie:new(), StopWords),
    juise_trie:search_prefix_leaf("dd", JTrie),

    % io:format("strstr result: ~ts~n", [find_strstr("героин", StopWords)]),
    % io:format("re result:     ~ts~n", [find_re("героин", CompiledRe)]),
    % io:format("trie result:   ~ts~n", [find_trie("героин", Trie)]),
    % io:format("re2 result:    ~ts~n", [find_re2("героин", CompiledRe2)]),

    io:format("strstr:  "),
    test_avg(?MODULE, find_strstr, [Message, StopWords], 50),
    io:format("regexp:  "),
    test_avg(?MODULE, find_re, [Message, CompiledRe], 50),
    io:format(" re2:    "),
    test_avg(?MODULE, find_re2, [Message, CompiledRe2], 50),
    io:format("trie:    "),
    test_avg(?MODULE, find_trie, [Message, Trie], 50),
    io:format("ahoc:    "),
    test_avg(?MODULE, find_ah, [Message, Ah], 50),
    io:format("juis:    "),
    test_avg(?MODULE, find_jtrie, [Message, JTrie], 50),

    garbage_collect().

find_strstr(Msg, List) ->
    find(fun(StopWord) -> string:str(Msg, StopWord) =/= 0 end, List).

find_re(Msg, Re) ->
    case re:run(Msg, Re, [notempty, {capture, first, list}]) of
        nomatch ->
            undefined;
        {match, [Value]} ->
            Value
    end.

find_re2(Msg, Re) ->
    case re2:match(unicode:characters_to_binary(Msg), Re, [{capture, first}]) of
        nomatch -> undefined;
        {match, [A]} -> A
    end.

find_trie([_|Tail] = Msg, Trie) ->
    case trie:find_prefix_longest(Msg, Trie) of
        {ok, Word, empty} -> Word;
        _ -> find_trie(Tail, Trie)
    end;
find_trie(_, _Trie) ->
    undefined.

find_ah(Msg, {A, B, C}) ->
    ahocorasick:find(A, B, C, unicode:characters_to_binary(Msg)).

find_jtrie(Msg, JTrie) ->
    juise_trie:search_prefix_leaf(Msg, JTrie).

test_avg(M, F, A, N) when N > 0 ->
    L = test_loop(M, F, A, N, []),
    Length = length(L),
    Min = lists:min(L),
    Max = lists:max(L),
    Med = lists:nth(round((Length / 2)), lists:sort(L)),
    Avg = round(lists:foldl(fun(X, Sum) -> X + Sum end, 0, L) / Length),
    io:format("Range: ~5b - ~5b µs\t"
    "Median: ~5b µs\t"
    "Average: ~5b µs~n",
        [Min, Max, Med, Avg]
    ),
    Med.

run_n_times(_M, _F, _A, 0) ->
    nop;
run_n_times(M, F, A, N) ->
    apply(M, F, A),
    run_n_times(M, F, A, N - 1).

test_loop(_M, _F, _A, 0, List) ->
    List;
test_loop(M, F, A, N, List) ->
    {T, _Result} = timer:tc(?MODULE, run_n_times, [M, F, A, 10]),
    test_loop(M, F, A, N - 1, [T | List]).


find(_Pred, []) -> undefined;
find(Pred, [Head | Rest]) ->
    case Pred(Head) of
        true -> Head;
        false -> find(Pred, Rest)
    end.

readlines(FileName, Num) ->
    {ok, Device} = file:open(FileName, [read, {encoding,utf8}]),
    get_all_lines(Device, [], Num).

get_all_lines(_, Accum, 0) ->
    Accum;
get_all_lines(Device, Accum, Num) ->
    case io:get_line(Device, "") of
        eof -> file:close(Device), Accum;
        Line -> get_all_lines(Device, Accum ++ [string:strip(Line, right, $\n)], Num - 1)
    end.

escape_word_for_re(Word) ->
    Word2 = re:replace(Word, "\\.", "\\\\.", [{return,list}, unicode]),
    Word3 = re:replace(Word2, "\\(", "\\\\(", [{return,list}, unicode]),
    re:replace(Word3, "\\)", "\\\\)", [{return,list}, unicode]).
