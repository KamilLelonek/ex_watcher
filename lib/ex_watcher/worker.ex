defmodule ExWatcher.Worker do
  use GenServer

  defstruct ~w(port os_type module)a

  @args_linux ['-F']
  @args_win32 ['-m', '-r']
  @args_osx   [
      '-c',
      'inotifywait $0 $@ & PID=$!; read a; kill $PID',
      '-m',
      '-e',
      'close_write',
      '-e',
      'moved_to',
      '-e',
      'create',
      '-e',
      'delete_self',
      '-e',
      'delete',
      '-r'
    ]

  def start_link(module),
    do: GenServer.start_link(__MODULE__, module, name: module)

  def init(module) do
    os_type = ExWatcher.os_type()
    port    = open_port(os_type, module.__dirs__)

    {:ok, %__MODULE__{port: port, os_type: os_type, module: module}}
  end

  def handle_info({port, {:data, {:eol, line}}}, %__MODULE__{port: port, os_type: os_type, module: module} = state) do
    {file_path, events} = os_type(os_type).line_to_event(line)

    module.callback(to_string(file_path), events)

    {:noreply, state}
  end

  def handle_info({port, {:exit_status, 0}}, %__MODULE__{port: port, module: module}) do
    module.callback(:stop)

    {:stop, :killed}
  end

  def handle_info(_, module),
    do: {:noreply, module}

  defp open_port(:fsevents, path),
    do: open_port(:fsevents.find_executable(), @args_linux, path)

  defp open_port(:inotifywait, path),
    do: open_port(:os.find_executable('sh'), @args_osx, path)

  defp open_port(:inotifywait_win32, path),
    do: open_port(:inotifywait_win32.find_executable(), @args_win32, path)

  defp open_port(executable, args, path) do
    Port.open(
      {
        :spawn_executable,
        executable
      },
      options(args, path)
    )
  end

  defp options(args, path) do
    [
      :stream,
      :exit_status,
      {:line, 16_384},
      {:args, args(args, path)},
      {:cd,   System.tmp_dir!()}
    ]
  end

  defp args(args, path),
    do: [[] | args, ] ++ format_path(path)

  defp format_path(paths) when is_list(paths) do
    for path <- paths,
      do: path |> Path.absname() |> to_char_list()
  end
  defp format_path(path),
    do: format_path([path])

  defp os_type(:inotifywait), do: ExWatcher.InotifyWait
  defp os_type(os_type),      do: os_type
end
