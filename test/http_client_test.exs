defmodule GraffitiRemoval.HTTPClientTest do
  use ExUnit.Case, async: true
  import GraffitiRemoval.HTTPClient
  alias GraffitiRemoval.Request
  alias GraffitiRemoval.Request
  doctest GraffitiRemoval
  
 # TODO: test http client: >= 2 tests per function, valid & invalid.

  @doc"""
  runner
      handle_fetch/2 # get_removal_requests_by_ward_and_date()

    getters: BIF unlikely to error
      get_ward_by_alderman/2 # find
        case
      filter_request_fields/1 # filter
      get_removal_requests_by_ward_and_date/2 # fetch()
        case

    fetches: HTTP requests likely to error bc invalid data
      fetch_wards/0
        case
      fetch_removal_requests/2 


    parsing: Jason lib unlikely to error
      parse_wards/1 # decode
      parse_ward_and_date/1 # decode
        case


    should be:
    1. fetch wards & parse :: tt
    2. fetch removal requests & parse :: tt
    3. find ward by alderman :: w
    4. make request structs :: w
    5. make report struct :: w


    External API Testing strategy
    1. Record Requests: ExVCR
    2. Mock Web Requests: Mock
    3. Mock HTTP Server: https://medium.com/flatiron-labs/rolling-your-own-mock-server-for-testing-in-elixir-2cdb5ccdd1a0
    4. FakeServer https://github.com/bernardolins/fake_server
    *5. Mox: http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/

  """

  def wards_fixture do
    [
      %{"ward" => 1, "alderman" => "John Dowell"}, 
      %{"ward"=> 2, "alderman" => "John Doe"}
    ]
  end

  def requests_fixture do
    [
      %{"ward" => 1, "alderman" => "John Dowell", "creation_date" => 2018-06-01, "street_address" => "123 Fake St"}, 
      %{"ward"=> 2, "alderman" => "John Doe", "creation_date" => 2018-06-02, "street_address" => "456 Fake St"}
    ]
  end


  test "get_ward_by_alderman/2" do
    alderman = "Dowell" 
    result = get_ward_by_alderman(alderman, wards_fixture())
    assert result == {:ok, %{"alderman" => "John Dowell", "ward" => 1}}
  end

  test "make_request/1" do
    [ward | t] = requests_fixture() 
    request = 
      %Request{
        ward: 1, 
        creation_date: 2018-06-01, 
        street_address: "123 Fake St"
      }
    assert make_request(ward) == request
  end

end