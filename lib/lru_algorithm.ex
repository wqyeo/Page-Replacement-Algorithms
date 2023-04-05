defmodule LRUAlgorithm do
  import TerminalColor
  import UserInputGetter

  defmodule PageFrame do
    defstruct holding_page: "", page_age: 99999
  end

  @spec run :: none
  def run do
    page_frame_count = UserInputGetter.get_positive_integer("Input the number of frames: ")
    page_frames =
      for _ <- 1..page_frame_count, do: %PageFrame{holding_page: "", page_age: 99999}

    # used for final output as a formatted table.
    output_table = [
      ["Page Fault Count" , "|",  "Accessing Page", "|", "Page Frames (HOLDING_PAGE_ID [AGE])"]
    ]
    page_sequences = UserInputGetter.get_page_list()

    acc_start = %{page_fault_count: 0, page_frames: page_frames}
    # Foreach page sequence
    result = Enum.reduce(page_sequences, acc_start, fn page, acc ->
      page_frames = Map.get(acc, :page_frames)

      # Current page doesn't exists in the page frame.
      if !Enum.member?(page_frames, %{holding_page: page}) do
        # Find oldest frame, put new page into it and reset age.
        oldest_frame_index = get_oldest_frame_index(page_frames)
        updated_frame = %PageFrame{holding_page: page, page_age: 0}
        page_frames = page_frames |> List.replace_at(oldest_frame_index, updated_frame)
        acc = Map.replace(acc, :page_frames, page_frames)

        # Increment page fault count
        updated_page_fault = Map.get(acc, :page_fault_count, 0) + 1
        acc = Map.replace(acc, :page_fault_count, updated_page_fault)
        acc
      else
        # Page existed before, just reset age to indicate used recently.
        existing_index = Enum.find_index(page_frames, & &1.holding_page == page)
        updated_frame = %PageFrame{holding_page: page, page_age: 0}
        page_frames = page_frames |> List.replace_at(existing_index, updated_frame)
        acc = Map.replace(acc, :page_frames, page_frames)
        acc
      end
    end)

    page_fault_count = Map.get(result, :page_fault_count, 0)
    IO.puts("Page Fault Count: #{page_fault_count}")
  end

  @spec get_oldest_frame_index([%PageFrame{}]) :: integer
  def get_oldest_frame_index(page_frames) do
    max_age_frame = Enum.max_by(page_frames, & &1.page_age)
    Enum.find_index(page_frames, fn frame -> frame.holding_page == max_age_frame.holding_page end)
  end
end
