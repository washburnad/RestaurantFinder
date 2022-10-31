# A service object that runs the GoogleApi::GetNearbyLocationsRequest
# and decorates the response to note the user's favorite restaurants

module Google
  class RestaurantSearch
    attr_reader :error, :results

    def initialize(params, user)
      @keyword = params[:keyword]
      @latitude = params[:latitude]
      @longitude = params[:longitude]
      @type = params[:type] || 'restaurant'
      @user = user
    end

    def run
      restaurants = make_request      
      @results = add_user_favorite_field(restaurants)

      true
    rescue GoogleApi::GoogleRequestError => error 
      @error = error.message
      
      false
    end

    private 

    attr_reader :keyword, :latitude, :longitude, :type, :user

    def add_user_favorite_field(restaurants)
      restaurants.map do |restaurant|
        restaurant['user_favorite'] = favorite_place?(restaurant['place_id'])

        restaurant
      end
    end

    def config
      GoogleApi::Config.new.tap do |config|
        config.api_key = Rails.application.credentials.config[:google][:api_key]
      end
    end

    def favorite_place_ids
      @favorite_place_ids ||= user.favorites.map(&:place_id)
    end

    def favorite_place?(place_id)
      favorite_place_ids.include?(place_id)
    end

    def make_request
      request = GoogleApi::GetNearbyLocationsRequest.new(
        config: config,
        keyword: keyword,
        latitude: latitude,
        longitude: longitude,
        type: type
      ).run 
      
      request.response['results']
    end
  end
end