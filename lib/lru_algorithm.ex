defmodule LRUAlgorithm do
  import TerminalColor
  import UserInputGetter

  defmodule PageFrame do
    defstruct holding_page: "NIL", page_age: 99999
  end

  @spec run :: none
  def run do
    page_frame_count = UserInputGetter.get_positive_integer("Input the number of frames: ")
    page_frames =
      for _ <- 1..page_frame_count, do: %PageFrame{holding_page: "NIL", page_age: 99999}

    # used for final output as a formatted table.
    output_table = [
      ["Page Fault Count" , "|",  "Accessing Page", "|", "Page Frames (HOLDING_PAGE_ID [AGE])"],
      ["", "|", "", "|"]
    ]

    page_sequences = UserInputGetter.get_page_list()

    acc_start = %{page_fault_count: 0, page_frames: page_frames, output_table: output_table}
    # Foreach page sequence
    result = Enum.reduce(page_sequences, acc_start, fn page, acc ->
      page_frames = Map.get(acc, :page_frames)

      # Increment the age of all page frames.
      page_frames = Enum.map(page_frames, fn frame ->
        %{frame | page_age: frame.page_age + 1}
      end)

      page_exists = Enum.any?(page_frames, fn frame -> frame.holding_page == page end)
      # Current page doesn't exists in the page frame.
      if !page_exists do
        # Find oldest frame, put new page into it and reset age.
        oldest_frame_index = get_oldest_frame_index(page_frames)
        updated_frame = %PageFrame{holding_page: page, page_age: 0}
        page_frames = page_frames |> List.replace_at(oldest_frame_index, updated_frame)
        acc = Map.replace(acc, :page_frames, page_frames)

        # Increment page fault count
        updated_page_fault = Map.get(acc, :page_fault_count, 0) + 1
        acc = Map.replace(acc, :page_fault_count, updated_page_fault)

        # Append current change to output table
        output_row = create_output_row(page, updated_page_fault, page_frames)
        updated_output_table = Map.get(acc, :output_table) ++ [output_row]
        acc = Map.replace(acc, :output_table, updated_output_table)

        acc
      else
        # Page existed before, just reset age to indicate used recently.
        existing_index = Enum.find_index(page_frames, & &1.holding_page == page)
        updated_frame = %PageFrame{holding_page: page, page_age: 0}
        page_frames = page_frames |> List.replace_at(existing_index, updated_frame)
        acc = Map.replace(acc, :page_frames, page_frames)

        page_fault_count = Map.get(acc, :page_fault_count, 0)
        # Append current change to output table
        output_row = create_output_row(page, page_fault_count, page_frames)
        updated_output_table = Map.get(acc, :output_table) ++ [output_row]
        acc = Map.replace(acc, :output_table, updated_output_table)

        acc
      end
    end)

    output_table = Map.get(result, :output_table)
    output_table |> Enum.each(fn row ->
      row |> Enum.map(&String.pad_leading(&1, 18, " ")) |> Enum.join(" ")  |> IO.puts()
    end)
  end

  @spec create_output_row(String, integer, [%PageFrame{}]) :: [String]
  def create_output_row(new_page, page_fault_count, page_frames) do
    row = ["#{page_fault_count}", "|", new_page, "|"]
    row = Enum.reduce(page_frames, row, fn frame, acc ->
      acc = acc ++ ["#{frame.holding_page} [#{frame.page_age}]"]
      acc
    end)
    row
  end

  @spec get_oldest_frame_index([%PageFrame{}]) :: integer
  def get_oldest_frame_index(page_frames) do
    max_age_frame = Enum.max_by(page_frames, & &1.page_age)
    Enum.find_index(page_frames, fn frame -> frame.holding_page == max_age_frame.holding_page end)
  end
end
