defmodule ExWatcher do
  use Application

  @os_type (
    case :os.type() do
     {:unix,  :darwin} -> :fsevents
     {:unix,  :linux}  -> :inotifywait
     {:win32, :nt}     -> :inotifywait_win32
      _                -> nil
    end
  )

  def start(_type, _args),
    do: start_application(os_not_supported?(), port_found?())

  def start_application(true, _),
    do: {:error, "Start failed: fs does not support the current operating system"}
  def start_application(_, false),
    do: {:error, "Start failed: OS port not found: #{@os_type}"}
  def start_application(_, _), do: ExWatcher.Supervisor.start_link()

  def os_not_supported?(), do: is_nil(@os_type)
  def port_found?(),       do: @os_type.find_executable()
  def known_events(),      do: @os_type.known_events()
  def os_type(),           do: @os_type
end
