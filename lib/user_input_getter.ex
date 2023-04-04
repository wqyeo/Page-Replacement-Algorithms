defmodule UserInputGetter do
  @moduledoc """
  Module used to fetch and sanitize/validate user inputs.
  """

  @spec get_positive_integer(String) :: pos_integer
  def get_positive_integer(message) do
    IO.puts(message)
    case IO.gets("") |> Integer.parse() do
      {number, _other} when number > 0 ->
        IO.puts("You entered: #{number}")
        number
      _ ->
        IO.puts("Please enter a positive integer.\n")
        get_positive_integer(message)
    end
  end

  @spec get_positive_float(String) :: float
  def get_positive_float(message) do
    IO.puts(message)
    case IO.gets("") |> Float.parse() do
      {number, _other} when number > 0 ->
        IO.puts("You entered: #{number}")
        number
      _ ->
        IO.puts("Please enter a positive float.\n")
        get_positive_float(message)
    end
  end
end
