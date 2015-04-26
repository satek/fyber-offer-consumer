class OffersController < ApplicationController

  def index
    @fyber_api = FyberApi.new   
  end

  def fetch
    @outcome = FyberApi.run(params[:fyber_api])
    respond_to do |format|
      format.js
    end
  end

end
