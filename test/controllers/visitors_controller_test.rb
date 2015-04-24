require "test_helper"

describe VisitorsController do

  it "presents visitors with a welcome page" do
    get :index
    assert_response :success
  end
  
end
