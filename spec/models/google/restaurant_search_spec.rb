require 'rails_helper'

RSpec.describe Google::RestaurantSearch do 
  describe '#run' do 
    subject { @search.run }

    let(:response) do 
      {
        'results' => [
          { 'place_id' => 'place-1-id' },
          { 'place_id' => 'place-2-id' }
        ]
      }
    end

    before do 
      @user = User.create(email: 'address@domain.com', password: 'password')      
      @user.favorites.create(place_id: 'place-2-id')

      params = {
        keyword: 'keyword-param',
        latitude: 'latitude-param',
        longitude: 'longitude-param'
      }

      allow(Rails.application.credentials).to receive(:config).
        and_return({ google: { api_key: 'google-api-key' } })

      @request = stub_get_nearby_locations_request(response)
      @search = described_class.new(params, @user)
    end
 
    context 'when the google request is succesful' do 

      before do 
        subject
      end
      
      it { is_expected.to eq(true) }

      it 'assigns the results with favorites noted' do 
        expect(@search.results).to eq(
          [
            {
              'place_id' => 'place-1-id',
              'user_favorite' => false
            },
            {
              'place_id' => 'place-2-id',
              'user_favorite' => true
            }
          ]
        )
      end
    end

    context 'when the google request is unsuccessful' do 
      before do 
        allow(@request).to receive(:run).and_raise(
          GoogleApi::GoogleRequestError, 'google-error-message'
        )

        subject
      end

      it { is_expected.to eq(false) }

      it 'assigns the correct error message' do 
        expect(@search.error).to eq('google-error-message')
      end
    end
  end

  def stub_get_nearby_locations_request(response)
    instance_double(GoogleApi::GetNearbyLocationsRequest).tap do |request|
      allow(request).to receive_messages(
        response: response,
        run: request
      )

      allow(GoogleApi::GetNearbyLocationsRequest).to receive(:new).
        and_return(request)
    end
  end
end