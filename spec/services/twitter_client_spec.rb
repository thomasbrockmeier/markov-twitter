require 'rails_helper'

describe TwitterClient do
  describe '.initialize' do
    context "creates instance" do
      it "TwitterClient with ENV variables" do
        c = TwitterClient.new
        expect(c.client.class).to eql(Twitter::REST::Client)

        expect(c.client.consumer_key).not_to be_empty
        expect(c.client.consumer_secret).not_to be_empty
        expect(c.client.bearer_token).not_to be_empty
      end
    end
  end
end
