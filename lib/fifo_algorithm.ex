defmodule FIFOAlgorithm do
  import TerminalColor
  import UserInputGetter

  defmodule PageFrame do
    defstruct holding_page: "NIL"
  end

  @spec run :: none
  def run do
    page_frame_count = UserInputGetter.get_positive_integer("Input the number of frames: ")
    page_frames =
      for _ <- 1..page_frame_count, do: %PageFrame{}

    # used for final output as a formatted table.
    output_table = [
      ["Page Fault Count" , "|",  "Accessing Page", "|", "Page Frames (HOLDING_PAGE_ID)"],
      ["", "|", "", "|"]
    ]

    page_sequences = UserInputGetter.get_page_list()

    acc_start = %{page_fault_count: 0, page_frames: page_frames, output_table: output_table, fifo_pointer: 0, frames_count: page_frame_count}
    # Foreach page sequence
    result = Enum.reduce(page_sequences, acc_start, fn page, acc ->
      page_frames = Map.get(acc, :page_frames)

      page_exists? = Enum.any?(page_frames, fn frame -> frame.holding_page == page end)
      if page_exists? do
        # Page existed before,
        page_fault_count = Map.get(acc, :page_fault_count, 0)
        # Append current change to output table
        output_row = create_output_row(page, page_fault_count, page_frames)
        updated_output_table = Map.get(acc, :output_table) ++ [output_row]
        acc = Map.replace(acc, :output_table, updated_output_table)

        acc
      else
        # Page doesn't exist.
        fifo_pointer = Map.get(acc, :fifo_pointer, 0)
        # Replace on fifo index.
        updated_frame = %PageFrame{holding_page: page}
        page_frames = List.replace_at(page_frames, fifo_pointer, updated_frame)
        acc = Map.replace(acc, :page_frames, page_frames)

        # Increment page fault count
        updated_page_fault = Map.get(acc, :page_fault_count, 0) + 1
        acc = Map.replace(acc, :page_fault_count, updated_page_fault)

        # Append current change to output table
        output_row = create_output_row(page, updated_page_fault, page_frames)
        updated_output_table = Map.get(acc, :output_table) ++ [output_row]
        acc = Map.replace(acc, :output_table, updated_output_table)

        # Increment fifo index
        fifo_pointer = fifo_pointer + 1
        if fifo_pointer >= Map.get(acc, :frames_count, 0) do
          fifo_pointer = 0
          Map.replace(acc, :fifo_pointer, fifo_pointer)
        else
          Map.replace(acc, :fifo_pointer, fifo_pointer)
        end
      end
    end)

    output_table = Map.get(result, :output_table)
    output_table |> Enum.each(fn row ->
      row |> Enum.map(&String.pad_leading(&1, 18, " ")) |> Enum.join(" ")  |> IO.puts()
    end)
  end

  @spec create_output_row(String, integer, [%PageFrame{}]) :: [String]
  def create_output_row(new_page, page_fault_count, page_frames) do
    row_header = ["#{page_fault_count}", "|", new_page, "|"]
    rows = Enum.map(page_frames, fn frame->
      "#{frame.holding_page}"
    end)
    row_header ++ rows
  end
end
