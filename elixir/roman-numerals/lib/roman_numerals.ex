defmodule RomanNumerals do
  @arabic_to_roman %{
    1 => "I",
    4 => "IV",
    5 => "V",
    9 => "IX",
    10 => "X",
    40 => "XL",
    50 => "L",
    90 => "XC",
    100 => "C",
    400 => "CD",
    500 => "D",
    900 => "CM",
    1000 => "M"
  }

  @roman_keys Map.keys(@arabic_to_roman) |> Enum.sort(&(&1 > &2))
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    to_roman(@roman_keys, number, "")
  end

  defp to_roman(_, 0, result), do: result

  defp to_roman([max | rest] = keys, number, result) do
    if number >= max do
      to_roman(keys, number - max, result <> @arabic_to_roman[max])
    else
      to_roman(rest, number, result)
    end
  end
end
