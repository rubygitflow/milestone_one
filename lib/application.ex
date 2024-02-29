defmodule MilestoneOne.Application do
  use Application # часть экосистемы Elixir

  # Супервайзер над ошибками приложения
  def start(_type, _opts) do # it's callback function
    children = [
      # {MilestoneOne.Server, 42} # здесь возможно задавать стартовые аргументы
      MilestoneOne.Server
    ]

    opts = [
      strategy: :one_for_one, # самая простая стратегия - перезапуск сервиса, если он "умирает"
      # one_for_all - все остальные процессы тоже будут остановлены и перезапущены
      # rest_for_one - будут перезапущены процессы в children, которые стоят после разрушенного 
      name: MilestoneOne.Supervisor
    ]

    Supervisor.start_link(children, opts) # этот супервайзер теперь будет следить за сервером
  end
end
