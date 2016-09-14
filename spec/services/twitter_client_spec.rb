require 'rails_helper'

describe TwitterClient do
  describe '.initialize' do
    context "when initialized" do
      it "TwitterClient reads ENV variables" do
        c = TwitterClient.new
        expect(c.client.class).to eql(Twitter::REST::Client)

        expect(c.client.consumer_key).not_to be_empty
        expect(c.client.consumer_secret).not_to be_empty
        expect(c.client.bearer_token).not_to be_empty
      end
    end
  end

  describe '.verify_account' do
    context 'when called' do
      it 'verifies a Twitter account\'s existence' do
        c = TwitterClient.new
        expect(c.verify_account('kanyewest')).to be true
      end
    end
  end

  describe '.get_all_tweets' do
    it 'gets up to 3200 tweets' do
      c = TwitterClient.new
      expect(c.get_all_tweets('twitterdev').length).to be_between(1, 3200).inclusive
    end
  end
end
