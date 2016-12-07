# ex_watcher

[![Build Status](https://travis-ci.org/KamilLelonek/ex_watcher.svg?branch=master)](https://travis-ci.org/KamilLelonek/ex_watcher)

An Elixir file change watcher based on [fs](https://github.com/synrc/fs)

## System Support

Just like [fs](https://github.com/synrc/fs#backends)

- Mac fsevent
- Linux inotify
- Windows inotify-win (untested)

NOTE: On Linux you need to install inotify-tools [`./scripts/install_inotify.sh`](scripts/install_inotify.sh).

## Usage

Put `ex_watcher` in the `deps` and `application` part of your mix.exs

``` elixir
defmodule MyProject.Mixfile do
  use Mix.Project

  # ...

  def application do
    [applications: [:ex_watcher, :logger]]
  end

  defp deps do
    [
      {:ex_watcher, "~> 0.1.0"},
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

