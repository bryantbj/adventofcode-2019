defmodule Day3 do
  @moduledoc """
  Documentation for Day3.
  """

  @input_path Path.join("priv", "input.txt")

  @doc """
  ## Examples
  iex> Day3.draw_path(["R1", "U2"])
  [%Pos{x: 1, y: 2}, %Pos{x: 1, y: 1}, %Pos{x: 1, y: 0}, %Pos{x: 0, y: 0}]
  """
  def draw_path(instructions) when is_list(instructions) do
    # root = %Pos{x: 0, y: 0}

    Enum.reduce(instructions, [%Pos{x: 0, y: 0}], fn x, [prev | _] = acc ->  Pos.move(prev, x) ++ acc end)
  end

  @doc """
  ## Examples
  iex> Day3.find_intersections([%Pos{x: 0, y: 0}, %Pos{x: 1, y: 0}], [%Pos{x: 2, y: 2}, %Pos{x: 1, y: 0}])
  [%Pos{x: 1, y: 0}]
  """
  def find_intersections(path1, path2) when is_list(path1) and is_list(path2) do
    MapSet.intersection(Enum.into(path1, MapSet.new), Enum.into(path2, MapSet.new)) |> MapSet.to_list()
  end
  def find_intersections([path1, path2]) do
    find_intersections(path1, path2)
  end

  @doc """
  iex> Day3.calc_nearest_intersection([%Pos{x: 3, y: 4}, %Pos{x: 3, y: 3}])
  6
  """
  def calc_nearest_intersection(intersections) when is_list(intersections) do
    intersections
    |> Enum.reject(& &1 == %Pos{x: 0, y: 0})
    |> Stream.map(&Pos.distance(%Pos{x: 0, y: 0}, &1))
    |> Enum.min
  end

  @doc """
  Preps the puzzle input for solving

  ## Examples
  iex> Day3.sanitize_input(~s[1,2,3
  ...>4,5,6])
  [~w[1 2 3], ~w[4 5 6]]
  """
  def sanitize_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Stream.filter(&(String.length(&1) > 0))
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ","))
    |> Enum.to_list()
  end

  @doc """
  iex>Day3.solve(~s[R75,D30,R83,U83,L12,D49,R71,U7,L72
  ...>U62,R66,U55,R34,D71,R55,D58,R83])
  159

  iex>Day3.solve(~s[R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
  ...>U98,R91,D20,R16,D67,R40,U7,R15,U6,R7])
  135
  """
  def solve(input \\ nil) do
      (input || File.read!(@input_path))
      |> sanitize_input()
      |> Stream.map(&draw_path/1)
      |> Enum.to_list()
      |> find_intersections()
      |> calc_nearest_intersection()
  end
end
