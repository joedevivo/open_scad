# escript hack with file_system
use Mix.Config
config :file_system, :fs_mac, executable_file: "./mac_listener"
config :file_system, :fs_windows, executable_file: "./inotifywait.exe"
