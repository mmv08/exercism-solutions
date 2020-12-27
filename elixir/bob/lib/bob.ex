defmodule Bob do
  def hey(input) do
    cond do
      silence?(input) -> "Fine. Be that way!"
      shouting?(input) && question?(input) -> "Calm down, I know what I'm doing!"
      shouting?(input) -> "Whoa, chill out!"
      question?(input) -> "Sure."
      true -> "Whatever."
    end
  end

  defp shouting?(input) do
    String.upcase(input) == input && input != String.downcase(input)
  end

  defp question?(input) do
    input
    |> String.trim()
    |> String.last() == "?"
  end

  defp silence?(input) do
    String.trim(input) == ""
  end
end
