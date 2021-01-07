defmodule Bowling do
  # i took inspiration from https://exercism.io/tracks/elixir/exercises/bowling/solutions/c48ce2345b6649b5bb25f5764aa59928
  @type frame :: {integer, integer} | {integer}
  @type game :: [frame]

  @negative_roll {:error, "Negative roll is invalid"}
  @roll_exceeding_pin_count {:error, "Pin count exceeds pins on the lane"}
  @game_not_over {:error, "Score cannot be taken until the end of the game"}
  @game_over {:error, "Cannot roll after game is over"}

  @strike_points 10
  @spare_points 10
  @max_pins 10
  @frames 10
  @frames_with_bonus_roll 11

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: any
  def start, do: []

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(game, integer) :: any | String.t()
  def roll(_, roll) when roll < 0, do: @negative_roll
  def roll(_, roll) when roll > @max_pins, do: @roll_exceeding_pin_count
  # bonus roll for a spare
  def roll([_, [last1, last2] | _] = game, _)
      when length(game) == @frames_with_bonus_roll and last1 + last2 == @strike_points,
      do: @game_over

  def roll([[last_roll] | _], roll)
      when last_roll < @strike_points and last_roll + roll > @spare_points,
      do: @roll_exceeding_pin_count

  def roll([[last | last2] | _] = game, _)
      when length(game) >= @frames and last + hd(last2) != @spare_points,
      do: @game_over

  def roll([[last_roll] | game], roll) when last_roll < @strike_points,
    do: [[last_roll, roll] | game]

  def roll(game, roll), do: [[roll] | game]

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @spec score(game) :: integer | String.t()
  def score(game) when length(game) < @frames, do: @game_not_over
  def score(game = [[@strike_points] | _]) when length(game) == @frames, do: @game_not_over

  def score(game = [[@strike_points] | [[@strike_points] | _]])
      when length(game) == @frames_with_bonus_roll,
      do: @game_not_over

  def score(game = [[first_roll, second_roll] | _])
      when length(game) == @frames and first_roll + second_roll == @spare_points,
      do: @game_not_over

  def score(game) do
    game |> Enum.reverse() |> get_frame_points |> Enum.sum()
  end

  defp get_frame_points(game, index \\ 1)
  defp get_frame_points(_, @frames_with_bonus_roll), do: []

  defp get_frame_points([frame | tail], index),
    do: [points_in(frame, tail) | get_frame_points(tail, index + 1)]

  defp points_in([@strike_points], tail),
    do: @strike_points + (tail |> List.flatten() |> Enum.take(2) |> Enum.sum())

  defp points_in([first_roll, second_roll], tail) when first_roll + second_roll == @spare_points,
    do: @spare_points + (tail |> List.flatten() |> hd())

  defp points_in([first_roll, second_roll], _), do: first_roll + second_roll
end
