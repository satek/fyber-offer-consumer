class FyberApi < ActiveInteraction::Base
  string :uid
  string :pub0
  integer :page
  
  def execute
    params = request_params.merge(hashkey: hashkey)
    resp = conn.get '/feed/v1/offers.json', params
    result = resp.body
    case result["code"]
    when "OK"
      result
    when "No Content"
      nil
    else
      Rails.logger.info result.inspect
      api_error!
    end
  rescue StandardError => e
    Rails.logger.info e.message
    Rails.logger.info e.backtrace.inspect
    api_error!
  end

  private

  def api_error!
    errors.add(:api, "An error occurred while retrieving data")
    nil
  end

  def request_params
    @request_params ||= 
      Rails.application.secrets.fyber_params.
            merge({
              "uid" => uid,
              "pub0" => pub0,
              "page" => page,
              "apple_idfa_tracking_enabled" => false,
              "timestamp" => Time.now.to_i
            })
  end

  def hashkey
    Digest::SHA1.hexdigest(hashkey_params)
  end

  def hashkey_params
    request_params.keys.sort.
                   inject('') { |sum, key| 
                      sum += "#{key.to_s}=#{request_params[key]}&"
                    } +
                    Rails.application.secrets.fyber_api["key"]
  end

  def conn
    Faraday.new(url: Rails.application.secrets.fyber_api["url"]) do |conn|
      conn.request :url_encoded
      conn.adapter  Faraday.default_adapter
      conn.response :json
    end
  end
end
