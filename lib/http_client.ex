defmodule GraffitiRemoval.HTTPClient do
  use HTTPoison.Base
  alias GraffitiRemoval.Request
  alias GraffitiRemoval.Report
  alias Jason

  # @spec get_ward_by_alderman(String) :: {:ok, number} | {:error, String}
  # def get_ward_by_alderman(alderman) do
  def get_ward_by_alderman(alderman, wards) do
    ward = 
      Enum.find(wards, fn(ward)-> 
        String.contains?(ward["alderman"],  alderman)
      end)

    case ward do
      x when is_map(x) -> {:ok, ward}
      _ -> {:error, "get_ward_by_alderman/2 error"}
    end
  end

  @spec get_removal_requests_by_ward_and_date(map, String) :: list(Request) 
  def get_removal_requests_by_ward_and_date(ward, date) do
    ward_value = ward["ward"]

    result = fetch_removal_requests(ward_value, date)
    case result do
      {:ok, response} -> parse_ward_and_date(response)
      {:error, error} -> error.reason
    end
  end

  def fetch_wards do
    result = 
    "https://data.cityofchicago.org/resource/7ia9-ayc2.json"
    |> HTTPoison.get()
     
    case result do
      {:ok, response} -> parse_wards(response)
      {:error, error} -> error.reason
    end
  end

  @spec fetch_ward(String) :: map 
  # defp fetch(alderman) do
  def fetch_ward(alderman) do
    "https://data.cityofchicago.org/resource/7ia9-ayc2.json?alderman=#{alderman}"
    |> HTTPoison.get()
  end

  @spec fetch_removal_requests(number, String) :: map
  # defp fetch(ward, date) do
  def fetch_removal_requests(ward, date) do
    "https://data.cityofchicago.org/resource/hec5-y4x5.json?ward=#{ward}&creation_date=#{date}"
    |> HTTPoison.get()
  end

  def parse_wards(response) do
    {:ok, decoded} = Jason.decode(response.body)
  end

  @spec parse_ward(map) :: number
  defp parse_ward(response) do
    {:ok, decoded} = Jason.decode(response.body)

    ward = 
      decoded
      |> hd
      |> Map.get("ward")
      |> String.to_integer()

    case ward do
      x when is_integer(x) -> {:ok, ward}
      _ -> {:error, "parse_ward/1 error"}
    end
  end

  @spec parse_ward_and_date(map) :: list(Request)
  defp parse_ward_and_date(response) do
    {:ok, decoded} = Jason.decode(response.body) 
    
    requests = 
      decoded
      |> Stream.map(&filter_request_fields/1)
      |> Enum.to_list

    case requests do
      x when is_list(x) -> {:ok, requests}
      _ -> {:error, "parse_ward_and_date/1 error"}
    end
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

  def handle_fetch(alderman, date) do
    with( 
      {:ok, wards} <- fetch_wards(),
      {:ok, ward} <- get_ward_by_alderman(alderman, wards),
      {:ok, requests} <- get_removal_requests_by_ward_and_date(ward, date)
    ) do

      {:ok, 
        %Report{
          alderman: ward["alderman"],
          ward: ward["ward"],
          date: date,
          requests_count: Enum.count(requests),
        }
      }
    end
  end


#  @spec try_query(function, integer) :: {atom, any}
#   def try_query(query, tries \\ 9)

#   def try_query(query, tries) when tries > 0 do
#     case query.() do
#       {:error, msg} ->
#         Process.sleep(Enum.random(20..100)) #
#         try_query(query, tries - 1)
#       {:ok, result} ->
#         {:ok, result}
#     end
#   end

#   def try_query(_query, tries) when tries <= 0 do
#     {:error, "Exceeded number of retries for query."} #
#   end


end