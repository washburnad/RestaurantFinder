module GoogleApi
  class Config
    attr_accessor :api_key
    attr_reader :base_uri

    DEFAULT_BASE_URI = 'https://maps.googleapis.com'.freeze 

    def initialize(base_uri: DEFAULT_BASE_URI)
      @base_uri = base_uri
    end
  end
end