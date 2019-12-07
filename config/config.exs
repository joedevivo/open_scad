use Mix.Config

config :open_scad, :watcher_path, "./models"

try do
  import_config "#{Mix.env()}.exs"
rescue
  _ -> :ok
end
