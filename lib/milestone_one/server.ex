defmodule MilestoneOne.Server do
  use GenServer, restart: :transient # перезапускать только по причине abnormal
                          # :permanent - постоянно перезапускать не обращая внимание на причину вылета
                          # :temporary - не надо перезапускать сервер

  alias MilestoneOne.Impl # такая запись позволяет опускать далее левую часть имени модуля

  # def start_link(opts) do
  def start_link(_) do
    GenServer.start_link(__MODULE__, :started, name: __MODULE__)
  end

  # def init({:started, stones_num}) do # главный callback GenServer
  def init(:started) do # главный callback GenServer
    # состояния игры:
    # :started

    # :game_in_progress

    # :game_ended

    IO.puts("Booting MilestoneOne server!")

    {:ok, {1, nil, :started}}
  end

  # дополнительная инструкция по установке начальных данных по num_stones
  # только перед началом игры - статус {player, nil, :started}
  def handle_call({:set, num_stones}, _, {player, nil, :started}) do
    Impl.do_set({player, num_stones})
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

  # 1. теперь обработаем инструкцию take у вызова 
  # GenServer.call(@server, {:take, ask_stones()})
  # 2. вторая переменная входных данных предназначена для идентификатора процесса, который нам всё ещё не нужен
  def handle_call({:take, num_stones}, _, {player, current_stones, :game_in_progress}) do
    Impl.do_take({player, num_stones, current_stones})
  end

  # обрабатываем остановку сервера
  def terminate(reason, state) do
    IO.inspect(reason)
    IO.inspect(state)
    "See you soon!" |> IO.puts
  end
end
