require "test_helper"

describe FyberApi do

  it "makes a call to fyber offer api with valid params" do
    outcome = 
      VCR.use_cassette("fyber_api_call", match_requests_on: [:method, :host]) do
        FyberApi.run({uid: "testuid", pub0: "testpub", page: "1"})
      end
    outcome.must_be :valid?
    result = outcome.result
    keys = result.keys
    keys.must_include "code"
    keys.must_include "message"
    keys.must_include "pages"
    keys.must_include "count"
    keys.must_include "information"
    keys.must_include "offers"
    result["information"].must_be_instance_of Hash
    result["offers"].must_be_instance_of Array
  end
end
