defmodule UserInputGetter do
  @moduledoc """
  Module used to fetch and sanitize/validate user inputs.
  """
  import TerminalColor

  @spec get_positive_integer(String) :: pos_integer
  def get_positive_integer(message) do
    TerminalColor.blue(message)
    case IO.gets("") |> Integer.parse() do
      {number, _other} when number > 0 ->
        number
      _ ->
        IO.puts("Please enter a positive integer.\n")
        get_positive_integer(message)
    end
  end

  @spec get_positive_float(String) :: float
  def get_positive_float(message) do
    TerminalColor.blue(message)
    case IO.gets("") |> Float.parse() do
      {number, _other} when number > 0 ->
        number
      _ ->
        IO.puts("Please enter a positive float.\n")
        get_positive_float(message)
    end
  end

  @spec get_page_list() :: [String.t]
  def get_page_list do
    TerminalColor.cyan("Input the page identifier in sequence as string, seperated by comma.")
    page_list = IO.gets("") |> String.trim() |> String.split(",") |> Enum.map(&String.trim/1)
    page_list
  end
end
