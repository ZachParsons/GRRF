defmodule GraffitiRemoval.HTTPClient do
  # use HTTPoison.Base
  alias GraffitiRemoval.Request
  alias GraffitiRemoval.Report
  alias Jason

  @spec fetch_wards :: {atom, list(map) | String} 
  def fetch_wards do
    wards = fn() ->
      "https://data.cityofchicago.org/resource/7ia9-ayc2.json"
      |> HTTPoison.get()
    end
    
    case try_fetch(wards, 3) do
      {:ok, response} -> parse_wards(response)
      _ -> {:error, "Error connecting, try again later."}
    end
  end

  @spec get_ward_by_alderman(String, list(map)) :: {atom, map | String}
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

  @spec fetch_removal_requests(integer, String) :: list
  def fetch_removal_requests(ward, date) do
    removal_requests = fn() -> 
      "https://data.cityofchicago.org/resource/hec5-y4x5.json?ward=#{ward}&creation_date=#{date}"
      |> HTTPoison.get()
    end
  
    try_fetch(removal_requests, 3)
  end

  @spec parse_wards(list) :: list(map)
  # @spec parse_wards(list) :: {atom, String | struct}
  def parse_wards(response) do
    Jason.decode(response.body) 
    # |> case do
    #   {:ok, result} -> {:ok, result} 
    #   {:error, reason} -> {:error, reason}
    # end
  end


  @spec parse_ward_and_date(map) :: list(Request)
  def parse_ward_and_date(response) do
    {:ok, decoded} = Jason.decode(response.body) 
    
    requests = 
      decoded
      # |> Stream.map(&filter_request_fields/1)
      |> Stream.map(&make_request/1)
      |> Enum.to_list

    case requests do
      x when is_list(x) -> {:ok, requests}
      _ -> {:error, "parse_ward_and_date/1 error"}
    end
  end

  # @spec filter_request_fields(map) :: Request
  @spec make_request(map) :: Request
  # defp filter_request_fields(request) do
  def make_request(request) do
    %Request{
      ward: request["ward"],
      creation_date: request["creation_date"],
      street_address: request["street_address"]
    }
  end

  @spec handle_fetch(map, String) :: {atom, Report}
  def handle_fetch(ward, date) do
    with( 
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

 @spec try_fetch(function, integer) :: {atom, any}
  def try_fetch(fetch, tries \\ 9)

  def try_fetch(fetch, tries) when tries > 0 do
    case fetch.() do
      {:error, _reason} ->
        Process.sleep(Enum.random(20..100)) #
        try_fetch(fetch, tries - 1)
      {:ok, result} ->
        {:ok, result}
      _ -> {:error, "Error connecting, try again later."}
    end
  end

  def try_fetch(_fetch, tries) when tries <= 0 do
    {:error, "Exceeded number of retries for fetch."} #
  end

end