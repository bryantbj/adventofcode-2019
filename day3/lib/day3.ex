defmodule Day3 do
  @moduledoc """
  Documentation for Day3.
  """

  @input_path Path.join("priv", "input.txt")

  @doc """
  ## Examples
  iex> Day3.draw_path(["R1", "U2"])
  [{3, %Pos{x: 1, y: 2}}, {2, %Pos{x: 1, y: 1}}, {1, %Pos{x: 1, y: 0}}, {0, %Pos{x: 0, y: 0}}]
  """
  def draw_path(instructions) when is_list(instructions) do
    Enum.reduce(instructions, [{0, %Pos{x: 0, y: 0}}], fn x, [prev | _] = acc ->  Pos.move(prev, x) ++ acc end)
  end

  @doc """
  Takes two paths (lists), groups each by their positions, reduces each so only the minimum step values are kept,
  then merges the group maps, filtering out any key/value pairs where the value length is less than 2, keeping
  only intersections.

  Returns a map.

  ## Examples
  iex> Day3.find_intersections([{1, %Pos{x: 0, y: 0}}, {2, %Pos{x: 1, y: 0}}], [{7, %Pos{x: 2, y: 2}}, {17, %Pos{x: 1, y: 0}}])
  %{ %Pos{x: 1, y: 0} => [ {2, %Pos{x: 1, y: 0}}, {17, %Pos{x: 1, y: 0}} ] }
  """
  def find_intersections(path1, path2) when is_list(path1) and is_list(path2) do
    [path1, path2]
    |> Stream.map(&Enum.group_by(&1, fn {_, pos} -> pos end))
    |> Stream.map(&pick_fewest_steps/1)
    |> Enum.to_list()
    |> concat_map_merge()
    |> Stream.reject(fn {k, _} -> k == %Pos{x: 0, y: 0} end) # we don't need the root coordinates
    |> Stream.filter(fn {_, v} -> length(v) > 1 end)
    |> Enum.into(%{})
  end
  def find_intersections([path1, path2]) do
    find_intersections(path1, path2)
  end

  @doc """
  For a given key in `map_of_grouped_positions`, the value is reduced so only the
  Tuple with the smallest first element is kept.

  ## Examples
  iex> Day3.pick_fewest_steps(%{a: [{1, "pos1"}, {17, "pos2"}]})
  %{a: [{1, "pos1"}]}
  """
  def pick_fewest_steps(map_of_grouped_positions) do
    Enum.reduce(map_of_grouped_positions, %{}, fn {k, v}, acc ->
      Map.put(acc, k, [Enum.min_by(v, fn {steps, _} -> steps end)])
    end)
  end

  @doc """
  Merges maps in `list_of_maps`. When a duplicate key is encountered, the values are concatenated.

  ## Examples
  iex> map1 = %{%Pos{x: 1, y: 1} => [{1, %Pos{x: 1, y: 1}}]}
  ...> map2 = %{%Pos{x: 1, y: 1} => [{13, %Pos{x: 1, y: 1}}]}
  ...> Day3.concat_map_merge([map1, map2])
  %{%Pos{x: 1, y: 1} => [{1, %Pos{x: 1, y: 1}}, {13, %Pos{x: 1, y: 1}}]}
  """
  def concat_map_merge(list_of_maps) do
    Enum.reduce(list_of_maps, %{}, fn
      map, acc -> Map.merge(acc, map, fn
        _, v1, v2 -> v1 ++ v2
      end)
    end)
  end

  @doc """
  iex> Day3.calc_nearest_intersection(%{%Pos{x: 1, y: 1} => [ {1, %Pos{x: 1, y: 1}}, {4, %Pos{x: 1, y: 1}} ] })
  5
  """
  def calc_nearest_intersection(intersections) when is_map(intersections) do
    intersections
    |> Map.values()
    |> Enum.reduce([], fn [{step1, _}, {step2, _}], acc -> [step1 + step2 | acc] end)
    |> Enum.min()
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

  def read_input_file do
    File.read!(@input_path)
  end

  @doc """
  iex>Day3.solve(~s[R75,D30,R83,U83,L12,D49,R71,U7,L72
  ...>U62,R66,U55,R34,D71,R55,D58,R83])
  610

  #iex>Day3.solve(~s[R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
  ...>U98,R91,D20,R16,D67,R40,U7,R15,U6,R7])
  410
  """
  def solve(input \\ nil) do
      (input || read_input_file())
      |> sanitize_input()
      |> Stream.map(&draw_path/1)
      |> Enum.to_list()
      |> find_intersections()
      |> calc_nearest_intersection()
  end
end
