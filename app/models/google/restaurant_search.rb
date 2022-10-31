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
      make_request
      
      @results = @request.response['results']

      @results.map do |result|
        result['user_favorite'] = favorite_place_ids.include?(result['place_id'])
      end
      
      @results
    rescue GoogleApi::GoogleRequestError => error 
      @error = error.message
      
      false
    end

    private 

    attr_reader :keyword, :latitude, :longitude, :type, :user

    def config
      GoogleApi::Config.new.tap do |config|
        config.api_key = Rails.application.credentials.config[:google][:api_key]
      end
    end

    def favorite_place_ids
      @favorite_place_ids ||= UserFavorite.where(
        user_id: user.id,
        place_id: @results.map { |location| location['place_id'] }
      ).map(&:place_id)
    end

    def make_request
      @request = GoogleApi::GetNearbyLocationsRequest.new(
        config: config,
        keyword: keyword,
        latitude: latitude,
        longitude: longitude,
        type: type
      ).run 
    end
  end
end