defmodule OpenSCAD.Application do
  use Application
  require Logger

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [OpenSCAD.Watcher]

    opts = [strategy: :one_for_one, name: OpenSCAD.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
