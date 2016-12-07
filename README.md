# ex_watcher

An Elixir file change watcher based on [fs](https://github.com/synrc/fs)

## System Support

Just like [fs](https://github.com/synrc/fs#backends)

- Mac fsevent
- Linux inotify
- Windows inotify-win (untested)

NOTE: On Linux you need to install inotify-tools:

```bash
which yum
if [[ $? -eq 0 ]]
then
    sudo yum install -y inotify-tools
else
    which apt-get
    if [[ $? -eq 0 ]]
    then
        sudo apt-get install -y inotify-tools
    fi
fi
```

## Usage

Put `ex_watcher` in the `deps` and `application` part of your mix.exs

``` elixir
defmodule MyProject.Mixfile do
  use Mix.Project

  # ...

  def application do
    [applications: [:exfswatch, :logger]]
  end

  defp deps do
    [
      {:exfswatch, "~> 0.1.0"},
    ]
  end
  
  # ...
end
```

write `lib/monitor.ex`

```elixir
defmodule Monitor do
  use ExWatcher.Watcher, dirs: ["/tmp/fswatch"]

  def callback(:stop) do
    IO.puts("STOP")
  end

  def callback(file_path, events) do
    IO.inspect({file_path, events})
  end
end
```

Execute in iex

```shell
iex > Monitor.start()
```

### List Events from Backend

```shell
iex > ExWatcher.known_events()
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `ex_watcher` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_watcher, "~> 0.1.0"}]
    end
    ```

  2. Ensure `ex_watcher` is started before your application:

    ```elixir
    def application do
      [applications: [:ex_watcher]]
    end
    ```

