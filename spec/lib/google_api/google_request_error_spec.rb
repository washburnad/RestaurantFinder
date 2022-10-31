require 'google_api/google_request_error'

RSpec.describe GoogleApi::GoogleRequestError do 
  it { is_expected.to be_kind_of(StandardError) }
end