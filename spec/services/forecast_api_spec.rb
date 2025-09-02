require 'rails_helper'

RSpec.describe ForecastApi, type: :service do
  let(:zipcode) { "27332" }
  let(:endpoint) { "/current" }
  let(:api_key) { "test_api_key_123" }
  let(:forecast_api) { described_class.new(zipcode, endpoint) }
  
  let(:mock_weather_response) do
    {
      "request" => {
        "type" => "Zipcode",
        "query" => zipcode,
        "language" => "en",
        "unit" => "f"
      },
      "location" => {
        "name" => "Sanford",
        "country" => "USA",
        "region" => "North Carolina",
        "lat" => "35.447",
        "lon" => "-79.138",
        "timezone_id" => "America/New_York",
        "localtime" => "2025-09-01 19:46",
        "localtime_epoch" => 1756755960,
        "utc_offset" => "-4.0"
      },
      "current" => {
        "observation_time" => "11:46 PM",
        "temperature" => 72,
        "weather_code" => 113,
        "weather_icons" => [
          "https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0001_sunny.png"
        ],
        "weather_descriptions" => [
          "Sunny"
        ],
        "astro" => {
          "sunrise" => "06:49 AM",
          "sunset" => "07:44 PM",
          "moonrise" => "03:50 PM",
          "moonset" => "12:14 AM",
          "moon_phase" => "Waxing Gibbous",
          "moon_illumination" => 57
        },
        "air_quality" => {
          "co" => "316.35",
          "no2" => "11.285",
          "o3" => "80",
          "so2" => "2.405",
          "pm2_5" => "7.215",
          "pm10" => "7.4",
          "us-epa-index" => "1",
          "gb-defra-index" => "1"
        },
        "wind_speed" => 6,
        "wind_degree" => 20,
        "wind_dir" => "NNE",
        "pressure" => 1020,
        "precip" => 0,
        "humidity" => 55,
        "cloudcover" => 0,
        "feelslike" => 77,
        "uv_index" => 0,
        "visibility" => 10,
        "is_day" => "no"
      }
    }.to_json
  end

  before do
    allow(ENV).to receive(:[]).with('API_KEY').and_return(api_key)
  end

  describe 'constants' do
    it 'has the correct BASE_URI' do
      expect(described_class::BASE_URI).to eq("http://api.weatherstack.com")
    end
  end

  describe 'URL construction' do
    it 'maintains URL structure consistency' do
      url = forecast_api.instance_variable_get(:@url)
      
      # Check URL components
      expect(url).to include(described_class::BASE_URI)
      expect(url).to include(endpoint)
      expect(url).to include("access_key=#{api_key}")
      expect(url).to include("units=f")
      expect(url).to include("query=#{zipcode}")
      
      # Check URL format
      expect(url).to match(/^http?:\/\/.*\?.*&.*/)
    end
  end

  describe 'HTTParty integration' do
    it 'includes HTTParty module' do
      expect(described_class.included_modules).to include(HTTParty)
    end

    it 'responds to HTTParty methods' do
      expect(described_class).to respond_to(:get)
      expect(described_class).to respond_to(:post)
    end
  end

  describe 'instance methods' do
    it 'responds to current_by_zipcode' do
      expect(forecast_api).to respond_to(:current_by_zipcode)
    end

    it 'responds to response' do
      expect(forecast_api).to respond_to(:response)
    end
  end

  describe 'HTTP request handling' do
    let(:mock_response) { double('HTTParty::Response') }

    before do
      allow(HTTParty).to receive(:get).and_return(mock_response)
    end

    it 'makes HTTP GET request to constructed URL' do
      expected_url = forecast_api.instance_variable_get(:@url)
      expect(HTTParty).to receive(:get).with(expected_url)
      forecast_api.response
    end

    it 'returns the HTTParty response' do
      expect(forecast_api.response).to eq(mock_response)
    end

    it 'returns response body from current_by_zipcode' do
      allow(mock_response).to receive(:body).and_return(mock_weather_response)
      allow(Rails.logger).to receive(:info)
      
      expect(forecast_api.current_by_zipcode).to eq(mock_weather_response)
    end
  end
end
