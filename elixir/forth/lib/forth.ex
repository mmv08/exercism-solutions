defmodule Forth do
  @opaque evaluator :: %Forth{env: Map.t(), stack: List.t()}
  defstruct env: %{}, stack: []

  @operators ["dup", "drop", "swap", "over", "+", "-", "*", "/"]

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new(), do: %Forth{}

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s |> tokenize(ev.env) |> eval_tokens(ev)
  end

  # Splits input string with commands into tokens given into
  # account evaluator's environment
  defp tokenize(s, env) do
    # clean non-words
    s |> String.replace(~r/[^\w\+-\\*\/]| /, " ") |> String.split() |> proceed_tokens(env)
  end

  # Proceeds tokens one by one
  defp proceed_tokens([], _), do: []

  defp proceed_tokens([token | rest] = s, env) when token == ":" do
    {d, t} = parse_definition_string(tl(rest), [])
    [{:define, hd(rest), d} | proceed_tokens(t, env)]
  end

  defp proceed_tokens([token | rest], env) do
    [to_token_format(token) | proceed_tokens(rest, env)]
  end

  defp to_token_format(word) do
    cond do
      String.downcase(word) in @operators -> {:operator, String.downcase(word)}
      is_string_integer?(word) -> {:integer, String.to_integer(word)}
      true -> {:word, word}
    end
  end

  # Parses string of format ": word-name definition ;"
  defp parse_definition_string([";" | t], res), do: {res, t}

  defp parse_definition_string([h | t], res) do
    parse_definition_string(t, [to_token_format(h) | res])
  end

  # Checks if string is an integer
  defp is_string_integer?(string) do
    String.match?(string, ~r/^\d+$/)
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    ev.stack |> Enum.reverse() |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
