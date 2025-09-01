require "httparty"

class ForecastApi
  include HTTParty

  BASE_URI = "http://api.weatherstack.com"

  def self.current_by_zipcode(zipcode)
    endpoint = "/current"
    self.new(zipcode, endpoint).current_by_zipcode
  end

  def initialize(zipcode, endpoint)
    @url = BASE_URI + endpoint + "?access_key=#{ENV['API_KEY']}&units=f&query=#{zipcode}"
    # Notes:
    # 1) Units f will return the temperature in Fahrenheit can always make this something that is
    #    selectable but would alter how we want to cache temperatures
    # 2) The argument is currently shown as zipcode because all queries will be based on zipcode for now
    #    The API take multiple different location based arguments (city, long/lat, etc.) so if we branch out to do it
    #    based on different locations we can either update the argument to be more generic or we can also make a base
    #    ForecastApi class that handles base logic and then make Child classes that would handle the different location
    #    type queries and any potential logic changes associated with it.
  end

  def current_by_zipcode
    response_body = response.body
    Rails.logger.info "API Response: #{response_body}"
    response_body
  end

  def response
    Rails.logger.info "Making API request to: #{@url}"
    response = HTTParty.get(@url)
    Rails.logger.info "API Response Status: #{response.code}"
    Rails.logger.info "API Response Headers: #{response.headers}"
    response
  end
end