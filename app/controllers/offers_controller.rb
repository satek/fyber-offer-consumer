class OffersController < ApplicationController

  def index
    @fyber_api = FyberApi.new   
  end

  def fetch
    @outcome = FyberApi.run(params[:fyber_api])
    @partial = partial_to_send
    respond_to do |format|
      format.js
    end
  end

  private

  def partial_to_send
    return "offer_errors" unless @outcome.valid?
    return "no_content" unless @outcome.result
    "offer_list"
  end

end
