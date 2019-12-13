defmodule Pos do
  defstruct x: nil, y: nil

  @doc """
  distance(PosA, PosB)

  Determines the Manhattan distance from PosA to PosB

  ## Examples
  iex> Pos.distance(%Pos{x: 0, y: 0}, %Pos{x: 3, y: 3})
  6

  iex> Pos.distance(%Pos{x: 1, y: 3}, %Pos{x: 4, y: 2})
  4
  """
  def distance(%Pos{x: a_x, y: a_y}, %Pos{x: b_x, y: b_y}) do
    abs(a_x - b_x) + abs(a_y - b_y)
  end

  @doc """
  Creates a series of `Pos`s, moving in a given direction

  move(starting_pos, instruction, movements)

  ## Examples
  iex> Pos.move(%Pos{x: 0, y: 0}, "R3")
  [%Pos{x: 3, y: 0}, %Pos{x: 2, y: 0}, %Pos{x: 1, y: 0}]

  iex> Pos.move(%Pos{x: 0, y: 0}, "U2")
  [%Pos{x: 0, y: 2}, %Pos{x: 0, y: 1}]
  """

  def move(pos, instruction, moves \\ [])

  # Up, increments `y`
  def move(%Pos{}, "U0", moves), do: moves
  def move(%Pos{x: x, y: y}, "U" <> _ = instruction, moves) do
    # num_spaces = String.to_integer(num_spaces)
    pos = %Pos{x: x, y: y + 1}
    [direction, num_spaces] = split_instruction(instruction)
    move(pos, "#{direction}#{num_spaces - 1}", [pos | moves])
  end

  # Down, decrements `y`
  def move(%Pos{}, "D0", moves), do: moves
  def move(%Pos{x: x, y: y}, "D" <> _ = instruction, moves) do
    # num_spaces = String.to_integer(num_spaces)
    pos = %Pos{x: x, y: y - 1}
    [direction, num_spaces] = split_instruction(instruction)
    move(pos, "#{direction}#{num_spaces - 1}", [pos | moves])
  end

  # Right, increments `x`
  def move(%Pos{}, "R0", moves), do: moves
  def move(%Pos{x: x, y: y}, "R" <> _ = instruction, moves) do
    # num_spaces = String.to_integer(num_spaces)
    pos = %Pos{x: x + 1, y: y}
    [direction, num_spaces] = split_instruction(instruction)
    move(pos, "#{direction}#{num_spaces - 1}", [pos | moves])
  end

  # Left, decrements `x`
  def move(%Pos{}, "L0", moves), do: moves
  def move(%Pos{x: x, y: y}, "L" <> _ = instruction, moves) do
    # num_spaces = String.to_integer(num_spaces)
    pos = %Pos{x: x - 1, y: y}
    [direction, num_spaces] = split_instruction(instruction)
    move(pos, "#{direction}#{num_spaces - 1}", [pos | moves])
  end

  @doc """
  iex>Pos.split_instruction("R1")
  ["R", 1]

  iex>Pos.split_instruction("D75")
  ["D", 75]
  """
  def split_instruction(str) do
    [direction | num] = str
    |> String.split("")
    |> Enum.filter(&String.length(&1) > 0)

    [direction, num |> Enum.join() |> String.to_integer()]
  end
end
