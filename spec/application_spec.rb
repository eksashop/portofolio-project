require 'spec_helper'

describe Eksa::Application do
  let(:app) do
    Eksa::Application.new
  end

  it "returns 404 for unknown routes" do
    get '/unknown'
    expect(last_response.status).to eq(404)
    expect(last_response.body).to include("Halaman Tidak Ditemukan")
  end

  it "can add and reach routes" do
    # Mock controller for testing
    stub_const("TestController", Class.new(Eksa::Controller) do
      def index
        "Hello Test"
      end
    end)

    app.add_route "/test", TestController, :index
    get '/test'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Hello Test")
  end
end
