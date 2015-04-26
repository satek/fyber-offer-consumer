require "test_helper"

describe OffersController do

  it "routes to offers form" do
    assert_routing '/offers', { controller: "offers", action: "index" }
  end

  it "routes to fetch offers method" do
    assert_routing({ method: 'post', path: '/offers/fetch' }, 
                   { controller: "offers", action: "fetch" })
  end

  it "#index presents offers form" do
    get :index
    assert_response :success
  end

  it "#fetch returns rendered offers" do
    VCR.use_cassette("fyber_api_call", match_requests_on: [:method, :host]) do
      xhr :post, :fetch, fyber_api: FactoryGirl.attributes_for(:link)
    end
    outcome = assigns(:outcome)
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
