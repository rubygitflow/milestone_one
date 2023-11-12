defmodule MilestoneOne.Server do
  use GenServer 

  alias MilestoneOne.Impl

  def init({:started, stones_num}) do # главный callback GenServer
    # состояния игры:
    # :started

    # :game_in_progress

    # :game_ended
    {:ok, {1, stones_num, :started}}
  end

  # формируем ответ на GenServer.call
  def handle_call(:current_state, _, {player, current_stones, _}) do  # callback GenServer
    # Здесь  {player, current_stones, _} == {1, stones_num, :started} из callback init
    {:reply, {player, current_stones}, {player, current_stones, :game_in_progress}}
    # {:атом_ответ, {ход_такого_игрока, камней_такое_количество}, новое_состояние_сервера}
    # новое_состояние_сервера = {входное_состояние_из_выхова=/player, current_stones/, новый_статус_игры}
  end

  # def handle_cast(:some_code, current_state) do
  #   # callback GenServer, который принимает инструкцию на исполнения без ожидаемого ответа
  #   # но функция должна что-то вернуть, поэтому используем в качестве ответа
  #   {:no_reply, new_state}
  # end

  # def handle_call({:take, num_stones}, _, {player, current_stones, :game_in_progress}) do
  #   Impl.do_take({player, num_stones, current_stones})
  # end

  # def terminate(reason, state) do
  #   IO.inspect(reason)
  #   IO.inspect(state)
  #   "See you soon!" |> IO.puts
  # end
end
