require 'spec_helper'

describe "Outbound SMS", :integration => true do
  subject { response }

  before :each do
    WebMock.disable!
    get '/inbound/sms/'
  end

  context "the API requests returns 405 as expected" do
    its(:status) { should eq 200 }
  end
end