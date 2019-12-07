defmodule OpenSCAD.CLI do
  @moduledoc """
  This module is for building the escript, which should be able to be installed
  locally and run outside of mix projects if that's too big a setup for your use
  case.
  """
  require Logger

  def main([path | _args]) do
    _ = extract_fs_mac()
    Application.put_env(:open_scad, :watcher_path, path)
    {:ok, _} = Application.ensure_all_started(:open_scad, :permanent)
    loop()
  end

  defp loop do
    Process.sleep(1000)
    loop()
  end

  defp extract_fs_mac() do
    {:ok, e} = :escript.extract(:escript.script_name(), [])
    _ = :zip.extract(e[:archive], file_list: ['mac_listener'])
    System.cmd("chmod", ["+x", "mac_listener"])
  end
end
