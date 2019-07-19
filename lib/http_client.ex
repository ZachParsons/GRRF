defmodule GraffitiRemoval.HTTPClient do
  use HTTPoison.Base
  alias GraffitiRemoval.Request
  alias GraffitiRemoval.Report
  alias Jason

  @spec get_ward_by_alderman(String) :: number
  def get_ward_by_alderman(alderman) do
    case fetch(alderman) do
      {:ok, response} -> parse_ward(response)
      {:error, error} -> error.reason
    end
  end

  @spec get_removal_requests_by_ward_and_date(number, Date) :: list(Request) 
  def get_removal_requests_by_ward_and_date(ward, date) do
    case fetch(ward, date) do
      {:ok, response} -> parse_ward_and_date(response)
      {:error, error} -> error.reason
    end
  end

  @spec fetch(String) :: map 
  # defp fetch(alderman) do
  def fetch(alderman) do
    HTTPoison.get("https://data.cityofchicago.org/resource/7ia9-ayc2.json?alderman=#{alderman}")
    |> IO.inspect(limit: :infinity)
  end

  @spec fetch(number, string) :: map
  # defp fetch(ward, date) do
  def fetch(ward, date) do
    HTTPoison.get("https://data.cityofchicago.org/resource/hec5-y4x5.json?ward=#{ward}&creation_date=#{date}")
    |> IO.inspect(limit: :infinity)    
  end

  @spec parse_ward(map) :: number
  defp parse_ward(response) do
    {:ok, decoded} = Jason.decode(response.body) 
    decoded
    |> hd
    |> Map.get("ward")
    |> IO.inspect(label: "HTTPClient parse_ward/1")
  end

  @spec parse_ward_and_date(map) :: list(Request)
  defp parse_ward_and_date(response) do
    {:ok, decoded} = Jason.decode(response.body) 
    decoded
    |> Stream.map(&filter_request_fields/1)
    |> IO.inspect(limit: :infinity)
    |> Enum.to_list
    |> IO.inspect(limit: :infinity)
  end

  @spec filter_request_fields(map) :: Request
  defp filter_request_fields(request) do
    %Request{
      ward: request["ward"],
      creation_date: request["creation_date"],
      # location_address: request["location_address"],
      street_address: request["street_address"]
    }
  end


  defp retry(fetch_fn, count) when count > 0 do
    IO.inspect(label: "line 87, retry count: #{count}")
    case fetch_fn.() do
      {:ok, report} -> report 
      {:error, reason} -> retry(fetch_fn, count-1)
    end
  end
  defp retry(fetch_fn, count) when count == 0, do: :error


  def handle_fetch(alderman, date) do
    with( 
      {:ok, ward} <- get_ward_by_alderman(alderman),
      {:ok, requests} <- get_removal_requests_by_ward_and_date(ward, date)
    ) do

      {:ok, 
        %Report{
          alderman: alderman,
          ward: ward,
          date: date,
          requests_count: Enum.count(requests),
        }
      }
    end
  end

end