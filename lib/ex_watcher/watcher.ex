defmodule ExWatcher.Watcher do
  defmacro __using__(options) do
    quote do
      def __dirs__(), do: unquote(Keyword.fetch!(options, :dirs))
      def start(),    do: ExWatcher.Supervisor.start_child(__MODULE__)
    end
  end
end
