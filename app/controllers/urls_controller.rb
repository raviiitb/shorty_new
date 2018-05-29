# frozen_string_literal: true

# This class has action which shortens the long url
class UrlsController < ApplicationController
  def index; end

  def shorten
    params = build_params shorten_params
    res = get_response url, params
    parsed_response = JSON.parse res
    @short_url = parsed_response['data']['url']
  rescue StandardError # For any error, user will be rescued to the index page
    flash[:alert] = 'Something went wrong!! Try again later.'
    redirect_to root_path
  end

  private

  # Whitelist the user inputted params
  def shorten_params
    params.permit :longUrl
  end

  # Creates the full API url
  def url
    "#{Rails.configuration.API_url}#{params[:action]}"
  end

  # Merge the access_token to the params
  def build_params(params)
    params.to_h.merge access_token: Rails.application.config.API_key
  end

  # Get the response from the external API using RestClient
  def get_response(url, params)
    RestClient.get url, params: params
  end
end
