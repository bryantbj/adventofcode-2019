defmodule Day2 do
  @moduledoc """
  Documentation for Day2.
  """

  @input_path Path.join("priv", "input.txt")

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

      iex>Day2.do_op([3], [3])
      {:error, "unrecognized opcode"}
  """
  def do_op(input, [1, loc_a, loc_b, loc_store]) do
    List.replace_at(input, loc_store, Enum.at(input, loc_a) + Enum.at(input, loc_b))
  end

  def do_op(input, [2, loc_a, loc_b, loc_store]) do
    List.replace_at(input, loc_store, Enum.at(input, loc_a) * Enum.at(input, loc_b))
  end

  def do_op(_, _) do
    {:error, "unrecognized opcode"}
  end

  @doc """
  ## Examples

    iex> Day2.get_next_op([1,2,3,4], 0)
    [1,2,3,4]

    iex> Day2.get_next_op([1,2,3,4,99], 4)
    {:halt}

    iex> Day2.get_next_op([3], 0)
    {:error, "unrecognized opcode"}
  """
  def get_next_op(input, index) do
    op = Enum.slice(input, index, 4)

    case op do
      [hd | _] when hd > 0 and hd < 3 -> op
      [99 | _] -> {:halt}
      _ -> {:error, "unrecognized opcode"}
    end
  end

  @doc """
    Replace position 1 with the value 12
    Replace position 2 with the value 2

    ## Examples
    iex> Day2.program_alarm([0,0,0,0])
    [0,12,2,0]
  """
  def program_alarm(input) do
    input
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
  end

  @doc """
  ## Examples

    iex> Day2.process_input([1,9,10,70,2,3,11,0,99,30,40,50], 0)
    [3500,9,10,70,2,3,11,0,99,30,40,50]

    iex> Day2.process_input([1,0,0,0,99], 0)
    [2,0,0,0,99]

    iex> Day2.process_input([2,3,0,3,99], 0)
    [2,3,0,6,99]

    iex> Day2.process_input([2,4,4,5,99,0], 0)
    [2,4,4,5,99,9801]

    iex> Day2.process_input([1,1,1,4,99,5,6,0,99], 0)
    [30,1,1,4,2,5,6,0,99]
  """
  def process_input(input, index) do
    with op when is_list(op) <- get_next_op(input, index),
         input when is_list(input) <- do_op(input, op) do
      process_input(input, index + 4)
    else
      {:halt} -> input
      {:error, error} -> {:error, error, input}
      _ -> {:error, "could not process_input", input}
    end
  end

  def solve(input \\ nil) do
    input =
      (input || File.read!(@input_path))
      |> String.trim()
      |> String.split(",")
      |> Stream.filter(&(String.length(&1) > 0))
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list()
      |> program_alarm()

    Enum.at(process_input(input, 0), 0)
  end
end
