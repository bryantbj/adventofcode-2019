defmodule Day2 do
  @moduledoc """
  Documentation for Day2.
  """

  @input_path Path.join("priv", "input.txt")
  @solution 19690720

  @doc """
  Processes one opcode
  [1, a, b, c] adds input[a] + input[b] and stores the sum in input[c]
  [2, a, b, c] multiplies input[a] + input[b] and stores the product in input[c]
  [99] halts the program
  [_] something went wrong

  ## Examples

      iex> Day2.do_op([1,4,5,3,5,5], [1,4,5,3])
      {:ok, [1,4,5,10,5,5]}

      iex> Day2.do_op([2,4,5,3,5,5], [2,4,5,3])
      {:ok, [2,4,5,25,5,5]}

      iex> Day2.do_op([3], [3])
      {:error, "unrecognized opcode"}
  """
  def do_op(input, [1, loc_a, loc_b, loc_store]) do
    a = Enum.at(input, loc_a)
    b = Enum.at(input, loc_b)
    result = a + b
    input = List.replace_at(input, loc_store, result)
    {:ok, input}
  end

  def do_op(input, [2, loc_a, loc_b, loc_store]) do
    a = Enum.at(input, loc_a)
    b = Enum.at(input, loc_b)
    result = a * b
    input = List.replace_at(input, loc_store, result)
    {:ok, input}
  end

  def do_op(_, _) do
    {:error, "unrecognized opcode"}
  end

  def to_action(input, op, a, b, loc_a, loc_b, c) do
    [op: op, a: {loc_a, a}, b: {loc_b, b}, result: Enum.at(input, 0), one: Enum.at(input, 1), two: Enum.at(input, 2), storage: c]
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
    Replace position 1 with the value of `noun`
    Replace position 2 with the value of `verb`

    ## Examples
    iex> Day2.set_noun_and_verb([0,0,0], 1, 2)
    [0,1,2]
  """
  def set_noun_and_verb(input, noun, verb) do
    input
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
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
         {:ok, input} when is_list(input) <- do_op(input, op) do
      process_input(input, index + 4)
    else
      {:halt} -> input
      {:error, error} -> {:error, error, input}
      _ -> {:error, "could not process_input", input}
    end
  end

  def sanitize_input(input) do
    input
      |> String.trim()
      |> String.split(",")
      |> Stream.filter(&(String.length(&1) > 0))
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list()
  end

  @doc """
  Solve uses Task.async/1 to parallelize the processing of the solution

  This could be simpler without the asynchronous tasks, but I just wanted
  an excuse to try it.
  """
  def solve(input \\ nil) do
    Solution.start_link(nil)

    tasks = []

    input =
      (input || File.read!(@input_path))
      |> sanitize_input()

    for noun <- 0..99 do
      for verb <- 0..99 do
        # 0, 0; 0, 1; 0, 2; ... 1, 0; 1, 1; 1, 2; ...
        if Solution.value() == nil do
          task = Task.async(fn ->
            program_input = set_noun_and_verb(input, noun, verb)

            case process_input(program_input, 0) do
              [@solution | _] -> Solution.update(100 * noun + verb)
              _ -> nil
            end
          end)

        tasks = [task | tasks]
        tasks
        end
      end
    end

    Enum.map(tasks, &Task.await/1)
    IO.puts Solution.value()
  end
end
