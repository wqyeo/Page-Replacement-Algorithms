defmodule TerminalColor do
  @moduledoc """
  Helper Module to print colors to the terminal.
  """

  def red(text), do: IO.puts "\e[31m#{text}\e[0m"
  def green(text), do: IO.puts "\e[32m#{text}\e[0m"
  def yellow(text), do: IO.puts "\e[33m#{text}\e[0m"
  def blue(text), do: IO.puts "\e[34m#{text}\e[0m"
  def magenta(text), do: IO.puts "\e[35m#{text}\e[0m"
  def cyan(text), do: IO.puts "\e[36m#{text}\e[0m"
end
