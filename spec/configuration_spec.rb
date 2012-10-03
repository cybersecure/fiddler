require 'spec_helper'

describe Fiddler::Configuration do
  describe 'when no options are given' do
    before do
      Fiddler.configure do |config|
      end
    end

    it 'defaults to using no cookies' do
      Fiddler.configuration.use_cookies.should be_false
    end

    it 'defaults to verifying the ssl connection' do
      Fiddler.configuration.ssl_verify.should be_true
    end
  end
end
