defmodule OpenSCAD.Watcher do
  use GenServer
  require Logger

  defstruct watcher_pid: nil 

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    Process.flag(:trap_exit, true)
    Logger.info "Running OpenSCAD watcher"
    Logger.info " on #{Mix.Project.compile_path(Mix.Project.config())}"
    {:ok, watcher_pid} = FileSystem.start_link(dirs: ["./models"])
    FileSystem.subscribe(watcher_pid)
    {:ok, %__MODULE__{watcher_pid: watcher_pid}}
  end
  
  def handle_info({:file_event, watcher_pid, {path, _events}}, %__MODULE__{:watcher_pid => watcher_pid}=state) do
    {:ok, script} = File.read path
    case string_to_quoted(String.to_charlist(script), 0, path, []) do
      {:error, {line, e}} ->
        Logger.error "#{path} compilation error"
        Logger.error "#{line}: #{e}"
      {:error, e} ->
        Logger.error "#{path} compilation error"
        Logger.error "#{inspect e}"
      _ -> 
        Logger.info "Compiling #{path}"
        try do
          Code.eval_file path
        catch
          e ->
            Logger.error "Error Compiling #{path}"
            Logger.error e
        after
          Logger.info "Done compiling"
        end
        ## For each module load, if using OpenSCAD.Model, then module.run
        modules = 
        try do
          Code.load_file(path)
        catch
          e ->
            Logger.error "Error loading #{path}"
            Logger.error e
        end
        for {mod, _} <- modules do
          if Kernel.function_exported?(mod, :is_open_scad_model?, 0) do
            try do
              #mod.run
            catch
              e ->
                Logger.error "Error Running #{mod}"
                Logger.error e
            end
          end
        end
      end
    {:noreply, state}
  end
  def handle_info({:file_event, watcher_pid, :stop}, %__MODULE__{:watcher_pid => watcher_pid}=state) do
    Logger.info("done")
    {:noreply, state}
  end
  def handle_info({:EXIT, from, reason}, state) do
    Logger.info "Exit #{from} : #{reason}"
    {:noreply, state}
  end
  def handle_info(msg, state) do
    Logger.error "Unknown message: #{inspect msg}"
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

end



        #for p <- Process.registered, do: Logger.info "#{inspect p} : #{p |> Process.whereis |> inspect}"
        #try do
        #  Mix.Tasks.Run.run(["#{path}"])
        #catch
        #  e ->
        #    Logger.error "Error Compiling #{path}"
        #    Logger.error e
        #after
        #  Logger.info "Done compiling"
        #end        
