defmodule ExWatcher.Supervisor do
  use Supervisor

  def start_link(),
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  def start_child(module),
    do: Supervisor.start_child(__MODULE__, [module])

  def init([]),
    do: supervise(children(), options())

  defp children() do
    [
      worker(ExWatcher.Worker, [], restart: :transient),
    ]
  end

  defp options(), do: [strategy: :simple_one_for_one]
end
