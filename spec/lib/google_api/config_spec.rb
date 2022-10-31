require 'google_api/config'

RSpec.describe GoogleApi::Config do 
  describe 'DEFAULT_BASE_URI' do 
    subject { described_class::DEFAULT_BASE_URI }
    it { is_expected.to eq('https://maps.googleapis.com') }
    it { is_expected.to be_frozen }
  end

  describe 'constructor' do 
    context 'when the base_uri is passed as an argument' do 
      subject { described_class.new(base_uri: 'base-uri') }

      it 'uses the passed in value' do 
        expect(subject.base_uri).to eq('base-uri')
      end
    end

    context 'when the base uri is not passed as an argument' do 
      subject { described_class.new }

      it 'uses the default value' do 
        expect(subject.base_uri).to eq(described_class::DEFAULT_BASE_URI)
      end
    end
  end
end