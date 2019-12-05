defmodule Day2 do
  @moduledoc """
  Documentation for Day2.
  """

  @input_path = Path.join("priv", "input.txt")

  @doc """
  Processes one opcode
  [1, a, b, c] adds input[a] + input[b] and stores the sum in input[c]
  [2, a, b, c] multiplies input[a] + input[b] and stores the product in input[c]
  [99] halts the program
  [_] something went wrong

  ## Examples

      iex>Day2.do_op([1,4,5,3,5,5], [1,4,5,3])
      [1,4,5,10,5,5]

      iex>Day2.do_op([2,4,5,3,5,5], [2,4,5,3])
      [2,4,5,25,5,5]

      iex>Day2.do_op([99], [99])
      {:halt}

      iex>Day2.do_op([3], [3])
      {:error, "something went wrong"}
  """
  def do_op(input, [1, loc_a, loc_b, loc_store]) do
    List.replace_at(input, loc_store, Enum.at(input, loc_a) + Enum.at(input, loc_b))
  end

  def do_op(input, [2, loc_a, loc_b, loc_store]) do
    List.replace_at(input, loc_store, Enum.at(input, loc_a) * Enum.at(input, loc_b))
  end

  def do_op(_, [99 | _]) do
    {:halt}
  end

  def do_op(_, _) do
    {:error, "something went wrong"}
  end



  def solve(input \\ nil) do
    (input || File.read!(@input_path))
    |> String.trim()
    |> String.split("\n")
    |> Stream.filter(& String.length(&1) > 0)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

end
