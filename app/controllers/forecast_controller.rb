class ForecastController < ApplicationController
  def index
    if params[:zipcode].present?
      begin
        @from_cache = Rails.cache.exist?("weather/#{params[:zipcode]}")
        response = Rails.cache.fetch("weather/#{params[:zipcode]}", expires_in: 30.minutes) do
          ForecastApi.current_by_zipcode(params[:zipcode])
        end
        @forecast_data = JSON.parse(response)
      rescue => e
        @error = "Unable to fetch weather data. Please check your zipcode and try again."
        Rails.logger.error "Forecast API error: #{e}"
      end
    end
  end
end
