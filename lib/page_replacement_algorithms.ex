defmodule PageReplacementAlgorithms do
  @moduledoc """
  Documentation for `PageReplacementAlgorithms`.
  """
  import UserInputGetter
  import TerminalColor
  import LRUAlgorithm
  import MRUAlgorithm

  @spec start :: none
  def start do
    TerminalColor.magenta("Select Page Replacement Algorithm to run")
    TerminalColor.cyan("1. (LRU) Least Recently Used")
    TerminalColor.cyan("2. (MRU) Most Recently Used")
    IO.puts("")

    algorithm_selection = UserInputGetter.get_positive_integer("Select Algorithm to use: (1/2)")
    case algorithm_selection do
      1 ->
        TerminalColor.magenta("\nLRU Selected")
        LRUAlgorithm.run()
      2 ->
        TerminalColor.magenta("\nMRU Selected")
        MRUAlgorithm.run()
      _->
        TerminalColor.red("Invalid selection... stopping.")
    end
  end
end
