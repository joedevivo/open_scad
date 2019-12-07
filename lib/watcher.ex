defmodule OpenSCAD.Watcher do
  @moduledoc """
  Giles forever!

  This is the only child spec for the OpenSCAD application. It watches
  `./models` by default, but you can configure that to whatever you want like
  so:

  ```elixir
  config :open_scad, :watcher_path, "./slayers"
  ```

  """
  use GenServer, restart: :permanent
  require Logger

  defstruct watcher_pid: nil

  def start_link([]) do
    GenServer.start(__MODULE__, [])
  end

  def init(_args) do
    Process.flag(:trap_exit, true)
    _ = Logger.info("Running OpenSCAD Watcher")
    use_correct_mac_listener()
    # TODO: Rethink the hardcoding of `./models`
    {pwd, 0} = System.cmd("pwd", [])

    path =
      Path.join(
        String.trim(pwd),
        Application.get_env(:open_scad, :watcher_path, "./models")
      )

    {:ok, watcher_pid} = FileSystem.start_link(dirs: [path])
    FileSystem.subscribe(watcher_pid)
    {:ok, %__MODULE__{watcher_pid: watcher_pid}}
  end

  # Compiles a file that's been changed
  defp compile(:stop), do: :stop

  defp compile(path) do
    {:ok, script} = File.read(path)

    case string_to_quoted(String.to_charlist(script), 0, path, []) do
      # `e` can be binary() or {binary(), binary()}
      {:error, {line, e, _token}} ->
        _ = Logger.error("#{path} compilation error")
        _ = Logger.error("  #{line}: #{inspect(e)}")
        :stop

      _ ->
        _ = Logger.info("Compiling #{path}")

        try do
          modules = Code.compile_file(path)
          _ = Logger.info("Done compiling")
          modules
        rescue
          e ->
            _ = Logger.error("Error Compiling #{path}")
            _ = Logger.error(inspect(e))
            :stop
        end
    end
  end

  defp maybe_run(:stop), do: :stop

  defp maybe_run(modules) do
    for {mod, _} <- modules do
      if Kernel.function_exported?(mod, :is_open_scad_model?, 0) do
        try do
          mod.main
        catch
          e ->
            _ = Logger.error("Error running #{mod}")
            _ = Logger.error(e)
        end
      end
    end
  end

  def handle_info(
        {:file_event, watcher_pid, {path, _events}} = f,
        %__MODULE__{:watcher_pid => watcher_pid} = state
      ) do
    _ = Logger.info("file event: #{inspect(f)}")

    _ =
      path
      |> maybe_path()
      |> compile()
      |> maybe_run()

    {:noreply, state}
  end

  def handle_info(
        {:file_event, watcher_pid, :stop},
        %__MODULE__{:watcher_pid => watcher_pid} = state
      ) do
    {:noreply, state}
  end

  def handle_info({:EXIT, from, reason}, state) do
    _ = Logger.info("Exit from #{inspect(from)} : #{inspect(reason)}")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    _ = Logger.error("Unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end

  defp string_to_quoted(string, start_line, file, opts) do
    case :elixir.string_to_tokens(string, start_line, file, opts) do
      {:ok, tokens} ->
        :elixir.tokens_to_quoted(tokens, file, opts)

      error ->
        error
    end
  end

  defp maybe_path(p) do
    case Path.extname(p) do
      ".ex" -> p
      ".exs" -> p
      _ -> :stop
    end
  end

  defp use_correct_mac_listener() do
    case :escript.script_name() do
      [] ->
        # Not an escript
        :ok

      _ ->
        # An escript
        executable_override = Path.absname("mac_listener")

        if File.exists?(executable_override) do
          file_system =
            Application.get_env(:file_system, :fs_mac, [])
            |> Keyword.put(:executable_file, executable_override)
            |> IO.inspect()

          Application.put_env(:file_system, :fs_mac, file_system)
        end
    end
  end
end
