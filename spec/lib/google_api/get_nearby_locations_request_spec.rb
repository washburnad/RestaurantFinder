require 'google_api/config'
require 'google_api/get_nearby_locations_request'
require 'google_api/google_request_error'
require 'httparty'

RSpec.describe GoogleApi::GetNearbyLocationsRequest do
  describe 'SEARCH_RADIUS' do 
    subject { described_class::SEARCH_RADIUS }
    it { is_expected.to eq(1500) }
  end 

  describe '#run' do 
    subject { @request.run }

    let(:keyword) { nil }
    let(:parsed_response) { { 'response' => 'data' } }
    let(:success) { true }

    before do 
      config = instance_double(
        GoogleApi::Config, 
        api_key: 'api-key',
        base_uri: 'base-uri'
      )

      kargs = {
        config: config,
        keyword: keyword,
        latitude: 'latitude-param',
        longitude: 'longitude-param',
        type: 'type-param'
      }.compact 

      @request = described_class.new(**kargs)

      @response = instance_double(
       HTTParty::Response,
       parsed_response: parsed_response,
       success?: success 
      )

      allow(HTTParty).to receive(:get).and_return(@response)
    end

    context 'always' do 
      it { is_expected.to eq(@request) }
    end

    context 'when keyword is not passed as an argument' do 
      before { subject }

      it 'makes the request with the correct arguments' do 
        expect(HTTParty).to have_received(:get).with(
          'base-uri/maps/api/place/nearbysearch/json',
          query: {
            location: 'latitude-param,longitude-param',
            radius: described_class::SEARCH_RADIUS,
            type: 'type-param',
            key: 'api-key'
          }
        )
      end
    end

    context 'when keyword is passed as an argument' do 
      let(:keyword) { 'keyword-param' }

      before { subject }

      it 'makes the request with the correct arguments' do 
        expect(HTTParty).to have_received(:get).with(
          'base-uri/maps/api/place/nearbysearch/json',
          query: {
            location: 'latitude-param,longitude-param',
            keyword: 'keyword-param',
            radius: described_class::SEARCH_RADIUS,
            type: 'type-param',
            key: 'api-key'
          }
        )
      end
    end

    context 'when successful' do 
      it 'returns the response' do 
        expect(subject.response).to eq(@response)
      end
    end

    context 'when unsuccessful' do 
      context 'when a 200 response includes an error message' do 
        let(:parsed_response) do 
          {
            'error_message' => 'google-error-message',
            'status' => 'INVALID_REQUEST'
          }
        end

        it 'raises a google request error' do           
          expect { subject }.to raise_error(
            GoogleApi::GoogleRequestError, 
            'INVALID_REQUEST, google-error-message'
          )
        end
      end

      context 'with an unsuccesful response code' do 
        let(:success) { false }

        it 'raises a google request error' do           
          expect { subject }.to raise_error(
            GoogleApi::GoogleRequestError, 
            @response.to_s
          )
        end
      end
    end
  end
end