defmodule Mix.Tasks.Report do
  use Mix.Task

  def run(_) do
    GraffitiRemoval.UIClient.main(IO)
  end


end