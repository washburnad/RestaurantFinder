module GoogleApi
  class GetNearbyLocationsRequest
    attr_reader :response 

    # search radius in meters
    SEARCH_RADIUS = 1500

    def initialize(config:, keyword: nil, latitude:, longitude:, type:)
      @config = config
      @keyword = keyword
      @latitude = latitude
      @longitude = longitude
      @type = type
    end

    def run 
      make_request
      validate_request
      
      self
    end

    private 

    def location 
      "#{latitude},#{longitude}"
    end

    def make_request         
      @response = HTTParty.get( 
        uri,
        query: query
      )
    end

    def query
      {
        location: location,
        keyword: keyword,
        radius: SEARCH_RADIUS,
        type: type,
        key: config.api_key
      }.compact
    end

    def uri
      "#{config.base_uri}/maps/api/place/nearbysearch/json"
    end

    def validate_request      
      if @response.key?('error_message').present?
        raise(GoogleRequestError, 
          "#{@response['status']}, #{@response['error_message']}"
        )
      elsif !@response.success?
        raise(GoogleRequestError, @response)
      end
    end

    attr_reader :config, :keyword, :latitude, :longitude, :type
  end
end