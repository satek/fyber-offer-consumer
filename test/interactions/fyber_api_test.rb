require "test_helper"

describe FyberApi do

  it "makes a call to fyber offer api with valid params" do
    outcome = 
      VCR.use_cassette("fyber_api_call", match_requests_on: [:method, :host]) do
        FyberApi.run(FactoryGirl.attributes_for(:link))
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

  it "doesn't make a call if page is invalid" do
    outcome = 
      VCR.use_cassette("fyber_api_call", match_requests_on: [:method, :host]) do
        FyberApi.run(FactoryGirl.attributes_for(:link, :invalid_page))
      end
    outcome.wont_be :valid?
    outcome.result.must_be_nil
    outcome.errors.keys.must_include :page
  end

  it "doesn't make a call if uid is missing" do
    outcome = 
      VCR.use_cassette("fyber_api_call", match_requests_on: [:method, :host]) do
        FyberApi.run(FactoryGirl.attributes_for(:link, :missing_uid))
      end
    refute outcome.valid?, "api call outcome must not be valid"
    assert_nil outcome.result, "api call result must not be present"
    outcome.errors.keys.must_include :uid
  end

  it "doesn't make a call if pub0 is missing" do
    outcome = 
      VCR.use_cassette("fyber_api_call", match_requests_on: [:method, :host]) do
        FyberApi.run(FactoryGirl.attributes_for(:link, :missing_pub0))
      end
    refute outcome.valid?, "api call outcome must not be valid"
    assert_nil outcome.result, "api call result must not be present"
    outcome.errors.keys.must_include :pub0
  end
end
