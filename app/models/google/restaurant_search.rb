module Google
  class RestaurantSearch
    attr_reader :error, :response

    def initialize(params)
      @keyword = params[:keyword]
      @latitude = params[:latitude]
      @longitude = params[:longitude]
      @type = params[:type] || 'restaurant'
    end

    def run
      make_request
      
      @response = @request.response
    rescue GoogleApi::GoogleRequestError => error 
      @error = error.message
      
      false
    end

    private 

    attr_reader :keyword, :latitude, :longitude, :type

    def config
      GoogleApi::Config.new.tap do |config|
        config.api_key = Rails.application.credentials.config[:google][:api_key]
      end
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