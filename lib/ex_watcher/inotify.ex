defmodule ExWatcher.Inotify do
  @regexp1 ~r/^(.*) ([A-Z_,]+) (.*)$/
  @regexp2 ~r/^(.*) ([A-Z_,]+)$/

  def line_to_event(line) do
    line
    |> to_string()
    |> scan()
    |> maybe_scan(line)
  end

  def scan(line) do
    case Regex.scan(@regexp1, line) do
      []                        -> {:error, :unknown}
      [[_, path, events, file]] -> {Path.join(path, file), parse_events(events)}
    end
  end

  def maybe_scan({:error, :unknown}, line) do
    case Regex.scan(@regexp2, line) do
      []                  -> {:error, :unknown}
      [[_, path, events]] -> {path, parse_events(events)}
    end
  end
  def maybe_scan(result, _), do: result

  def parse_events(events) do
    events
    |> String.split(",")
    |> Enum.map(&convert_flag/1)
  end

  def convert_flag("CLOSE_WRITE"), do: :modified
  def convert_flag("CLOSE"),       do: :closed
  def convert_flag("CREATE"),      do: :create
  def convert_flag("MOVED_TO"),    do: :renamed
  def convert_flag("ISDIR"),       do: :isdir
  def convert_flag("DELETE_SELF"), do: :delete_self
  def convert_flag("DELETE"),      do: :deleted
  def convert_flag(_),             do: :unknown
end
