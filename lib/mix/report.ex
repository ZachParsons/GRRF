defmodule Mix.Tasks.Report do
  use Mix.Task

  def run(_) do
    Application.ensure_all_started(:hackney)
    GraffitiRemoval.UIClient.main(IO)
  end


end