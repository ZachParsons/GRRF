defmodule GraffitiRemoval.UIClient do
  alias GraffitiRemoval.HTTPClient

  # TODO: handle UI errors: empty strings, invalid formats, 
  # by giving error message & repeating Qs
  # also "q" to quit

  def main(io \\ IO) do
    wards = 
      case HTTPClient.fetch_wards do
        {:ok, wards} -> wards
        {:error, reason} -> quit(self(), reason)
      end

    greeting()

    ward = 
      prompt_for_alderman()
      |> receive_input(io)
      |> get_ward_by_alderman(wards)
    
    date = 
      prompt_for_date()
      |> receive_input(io)
    
    case HTTPClient.handle_fetch(ward, date) do
      {:ok, report} -> print_report(report)
      {:error, reason} -> quit(self(), reason)
    end
  end

  defp get_ward_by_alderman(alderman, wards) do
    ward = 
      Enum.find(wards, fn(ward)-> 
        String.contains?(ward["alderman"],  alderman)
      end)

    case ward do
      w when is_map(w) -> ward
      _ -> "Alderman not found"
    end
  end

  def receive_input(message, io) do
    io.gets(message)
    |> String.trim
  end

  defp quit(pid, reason) do
    Process.exit(pid, reason)
  end

  defp greeting, do: IO.puts "Welcome to The Graffiti Removal Requests Reporter."
  
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