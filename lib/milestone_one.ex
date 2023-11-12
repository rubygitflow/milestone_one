defmodule MilestoneOne do
  def run(initial_stones_num \\ 30) do
    MilestoneOne.Client.play(initial_stones_num)
  end
end
