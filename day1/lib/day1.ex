defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  @input_path Path.join("priv", "input.txt")

  @doc """
  Calculates the fuel needed for a module with a given `mass`. If `mass` is not an integer, returns 0

  Fuel required to launch a given module is based on its mass.
  Specifically, to find the fuel required for a module,
  take its mass, divide by three, round down, and subtract 2.

  ## Examples
      ### Integer
      iex> Day1.calc_fuel(12)
      2

      iex> Day1.calc_fuel(14)
      2

      iex> Day1.calc_fuel(1969)
      654

      iex> Day1.calc_fuel(100756)
      33583

      ### List
      iex> Day1.calc_fuel([12, 14])
      4

      iex> Day1.calc_fuel([12, 14, 1969, 100756])
      34241
  """
  def calc_fuel(mass) when is_integer(mass) do
    mass
    |> Integer.floor_div(3)
    |> Kernel.-(2)
  end

  def calc_fuel(masses) when is_list(masses) do
    masses
    |> Stream.map(&calc_fuel/1)
    |> Enum.sum()
  end

  def calc_fuel(_), do: 0

  @doc """
  Loads given puzzle input, splits on new lines and feeds it to calc_fuel/1

  ## Examples
      iex> Day1.solve(~s'''
      ...>12
      ...>14
      ...>''')
      4
  """
  def solve(input \\ nil) do
    (input || File.read!(@input_path))
    |> String.trim()
    |> String.split("\n")
    |> Stream.filter(&(String.length(&1) > 0))
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
    |> calc_fuel()
  end
end
