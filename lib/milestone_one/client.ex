defmodule MilestoneOne.Client do
  @server MilestoneOne.Server  # атрибут для сервера приложения

  # превращаем приложение в консольное
  def main(argv) do
    parse(argv) |> set_initial_stones()

    next_turn()
  end

  defp set_initial_stones(stones_to_set) do
    case GenServer.call(@server, {:set, stones_to_set}) do
      {:stones_set, player, num_stones} ->
        IO.puts("Welcome! It's player #{player} turn. #{num_stones} in the pile.")

      {:error, reason} ->
        IO.puts("\nThere was an error: #{reason}")
        exit(:normal)
    end
  end

  defp parse(arguments) do
    # OptionParser встроено в elixir
    {opts, _, _ } = OptionParser.parse(arguments, switches: [stones: :integer])

    opts |> Keyword.get(
      :stones,
      Application.get_env(:milestone_one, :default_stones)
    ) # достаём значения по умолчанию, если пользователь не ввел количество камней из терминала
    # источник:
    # defmodule MilestoneOne.MixProject do
    #   def application do
    #     [
    #       env: [ default_stones: 30 ],
  end

  def play(initial_stones_num) do
    GenServer.start_link(@server, {:started, initial_stones_num}, name: @server)

    {player, current_stones} = GenServer.call(@server, :current_state)

    IO.puts("Welcome! It's player #{player} turn. #{current_stones} in the pile.")

    next_turn()
  end

  defp next_turn do
    case GenServer.call(@server, {:take, ask_stones()}) do
      {:next_turn, next_player, stones_count} ->
        IO.puts("\nPlayer #{next_player} turns next. Stones: #{stones_count}")
        next_turn()

      {:winner, winner} ->
        IO.puts("\nPlayer #{winner} wins!!!")

      {:error, reason} ->
        IO.puts("\nThere was an error: #{reason}")
        next_turn()
    end
  end

  defp ask_stones do
    IO.gets("\nPlease take from 1 to 3 stones:\n") |>
    String.trim() |>
    Integer.parse() |>
    stones_to_take()
  end

  defp stones_to_take({count, _}), do: count
  defp stones_to_take(:error), do: 0
end
