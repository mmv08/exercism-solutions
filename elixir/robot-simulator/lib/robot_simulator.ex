defmodule RobotSimulator.Robot do
  defstruct direction: nil, position: nil
end

defmodule RobotSimulator do
  alias RobotSimulator.Robot
  @directions [:north, :east, :south, :west]

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    cond do
      !Enum.member?(@directions, direction) -> {:error, "invalid direction"}
      !is_position_valid(position) -> {:error, "invalid position"}
      true -> %Robot{direction: direction, position: position}
    end
  end

  defp is_position_valid(position) when is_tuple(position) == false, do: false

  defp is_position_valid(position) do
    x = elem(position, 0)
    y = elem(position, 1)

    is_integer(x) and is_integer(y) and tuple_size(position) == 2
  end

  def get_new_position(robot) do
    {x, y} = robot.position

    case robot.direction do
      :north -> {x, y + 1}
      :east -> {x + 1, y}
      :west -> {x - 1, y}
      :south -> {x, y - 1}
    end
  end

  def proceed_instruction(robot, instruction) do
    case instruction do
      "L" ->
        {:cont,
         %{
           robot
           | direction:
               Enum.at(
                 @directions,
                 Enum.find_index(@directions, fn d -> d == robot.direction end) - 1
               )
         }}

      "R" ->
        {:cont,
         %{
           robot
           | direction:
               Enum.at(
                 @directions,
                 Enum.find_index(@directions, fn d -> d == robot.direction end) + 1 - 4
               )
         }}

      "A" ->
        {:cont, %{robot | position: get_new_position(robot)}}

      _ ->
        {:halt, {:error, "invalid instruction"}}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    String.graphemes(instructions)
    |> Enum.reduce_while(robot, fn i, r -> proceed_instruction(r, i) end)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.position
  end
end
