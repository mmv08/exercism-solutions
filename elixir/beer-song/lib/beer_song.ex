defmodule BeerSong do
  @zero_bottles_verse """
  No more bottles of beer on the wall, no more bottles of beer.
  Go to the store and buy some more, 99 bottles of beer on the wall.
  """

  @spec verse(integer) :: String.t()
  defp generic_verse(number) do
    noun = if number > 1, do: "bottles", else: "bottle"
    pronoun = if number == 1, do: "it", else: "one"
    bottles_left = if number > 1, do: number - 1, else: "no more"
    pronoun_left = if bottles_left == 1, do: "bottle", else: "bottles"

    """
    #{number} #{noun} of beer on the wall, #{number} #{noun} of beer.
    Take #{pronoun} down and pass it around, #{bottles_left} #{pronoun_left} of beer on the wall.
    """
  end

  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    cond do
      number == 0 -> @zero_bottles_verse
      true -> generic_verse(number)
    end
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    first..last = range

    Enum.reduce((first - 1)..last, verse(first), fn num, output ->
      "#{output}\n#{verse(num)}"
    end)
  end
end
