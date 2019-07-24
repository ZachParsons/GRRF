defmodule GraffitiRemoval.UIClient do
  alias GraffitiRemoval.HTTPClient

  def main(io \\ IO) do
    greeting()

    alderman = 
      prompt_for_alderman()
      |> receive_input(io)
    
    date = 
      prompt_for_date()
      |> receive_input(io)
    
    case HTTPClient.handle_fetch(alderman, date) do
      {:ok, report} -> print_report(report)
      {:error, reason} -> print_error(reason)
    end
  end

  # TODO: handle UI errors: empty strings, invalid formats, 
  # by giving error message & repeating Qs
  # also "q" to quit

  def receive_input(message, io) do
    # io.gets(message <> "\n")
    io.gets(message)
    |> String.trim
  end

  defp greeting, do: IO.puts "Welcome to The Graffiti Removal Requests Reporter. (Enter 'q' to quit.)
  "
  
  defp prompt_for_alderman do
    "Please enter the last name of the Alderman of the ward on which to report in this format: Dowell\n"
  end
  
  defp prompt_for_date do
    "Please enter year and month on which to report in this format: 2018-06\n"
  end

  defp print_report(report) do
    IO.puts "
      Graffiti Removal Requests Report
      ________________________________ 
      Alderman: #{report.alderman}
      Ward: #{report.ward}
      Year & Month: #{report.date}
      Total Requests Count: #{report.requests_count}\n"
  end

  def print_error(reason) do
    IO.puts "Error: #{reason}. Try again later."
  end

end