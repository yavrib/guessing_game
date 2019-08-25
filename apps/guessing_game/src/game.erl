-module(game).

-export([guess/1]).
-export([start_link/0]).

guess(State) ->
  case State of
    {new_game} ->
      Number = rand:uniform(100),
      io:format("Let me tell you the secret number: ~w~n", [Number]),
      guess({guess, Number});
    {guess, Number} ->
      Guess = case io:fread("Pick a number\n", "~d") of
        {ok, [N]} -> N;
        _ -> io:format("Error\n")
      end,
      case Guess of
        G when G > Number ->
          io:fwrite("Too big\n"),
          guess({guess, Number});
        G when G < Number ->
          io:fwrite("Too small\n"),
          guess({guess, Number});
        G when G == Number ->
          io:fwrite("Win\n"),
          guess({win})
      end;
    {win} ->
      Answer = case io:fread("Wanna play again? Y/N\n", "~s") of
        {ok, [Value]} -> Value;
        _ -> io:format("Error\n")
      end,
      case Answer of
        "Y" -> guess({new_game});
        "N" -> io:format("Bye\n")
      end
  end.

start_link() ->
  {ok, self()}.
