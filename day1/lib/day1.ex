defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  @input_path Path.join("priv", "input.txt")

  @doc """
  Calculates the fuel needed for a module with a given `mass`. If `mass` is not an integer
  or `mass` is < 1, returns 0.

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
  def calc_fuel(mass) when is_integer(mass) and mass > 0 do
    fuel =
      mass
      |> Integer.floor_div(3)
      |> Kernel.-(2)

    (fuel > -1 && fuel) || 0
  end

  def calc_fuel(masses) when is_list(masses) do
    masses
    |> Stream.map(&calc_fuel/1)
    |> Enum.sum()
  end

  def calc_fuel(_), do: 0

  @doc """
  Recusively calls calc_fuel/1 adding the result to `total` until `mass` is 0.

  ## Examples
  iex>Day1.calc_total_fuel(14)
  2

  iex>Day1.calc_total_fuel(1969)
  966

  iex>Day1.calc_total_fuel(100756)
  50346
  """
  def calc_total_fuel(mass, total \\ 0) when is_integer(total) and is_integer(mass) do
    case calc_fuel(mass) do
      new_mass when new_mass > 0 -> calc_total_fuel(new_mass, total + new_mass)
      _ -> total
    end
  end

  @doc """
  Loads given puzzle input or puzzle input file if no input is given, splits on new lines, and calculates total fuel

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
    |> Stream.map(&calc_total_fuel(&1))
    |> Enum.sum()
  end
end
