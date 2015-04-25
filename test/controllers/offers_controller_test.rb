require "test_helper"

describe OffersController do

  it "routes to offers form" do
    assert_routing '/offers', { controller: "offers", action: "index" }
  end

  it "routes to fetch offers method" do
    assert_routing({ method: 'post', path: '/offers/fetch' }, 
                   { controller: "offers", action: "fetch" })
  end

  it "presents visitors with a welcome page" do
    get :index
    assert_response :success
  end
  
end
