require 'spec_helper'
require 'rails_helper'
require "#{ Rails.root }/spec/support/auth_helper"

describe "Inbound SMS", type: :request  do
  include AuthHelper

  it 'send 405 for get' do
    get '/inbound/sms/'

    expect(response).to have_http_status(405)
  end

  it 'send 405 for patch' do
    patch '/inbound/sms/'

    expect(response).to have_http_status(405)
  end

  it 'send 405 for put' do
    put '/inbound/sms/'

    expect(response).to have_http_status(405)
  end

  it 'send 405 for delete' do
    delete '/inbound/sms/'

    expect(response).to have_http_status(405)
  end

  it 'sends 403 for unauthorized request' do
    post '/inbound/sms/'

    expect(response).to have_http_status(403)
  end


  # describe 'Unauthorized post request' do
  #   before(:each) do
  #     http_login("username", "password")
  #   end

  #   it 'sends 405 for unauthorized login' do
  #     post '/inbound/sms/', {}, @env
  #     expect(response).to have_http_status(403)
  #   end
  # end


  # # describe 'Authorized Post Requests' do
  # #   it 'send 403 for unauthorized post' do
  # #     before


  # #     post '/inbound/sms/', { username: }

  # #     expect(response).to have_http_status(405)
  # #   end
  # end

  
end


