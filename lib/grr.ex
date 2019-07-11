defmodule Mix.Tasks.Grr do
  use Mix.Task

  def run(_) do
    UIClient.main([])
  end


end