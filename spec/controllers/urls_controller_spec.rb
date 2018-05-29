# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET index' do
    it 'render the index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET shorten' do
    context 'Error' do
      it 'should render index with flash' do
        allow(controller).to \
          receive(:get_response).with(anything, anything)
                                .and_return []
        get :shorten, params: { longUrl: '' }
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq 'Something went wrong!! Try again later.'
        expect(assigns :short_url).to eq nil
      end
    end

    context 'Success' do
      it 'should render shorten' do
        api_response = {
          "data": {
            "global_hash": '900913',
            "hash": 'ze6poY',
            "long_url": 'http://test.de/',
            "new_hash": 0,
            "url": 'http://bit.ly/ze6poY'
          },
          "status_code": 200,
          "status_txt": 'OK'
        }.to_json
        allow(controller).to receive(:get_response).with(anything, anything)
                                                   .and_return api_response
        get :shorten, params: { longUrl: 'http://test.de/' }
        expect(response).to render_template :shorten
        expect(flash[:alert]).to eq nil
        expect(assigns :short_url).to eq 'http://bit.ly/ze6poY'
      end
    end
  end
end
