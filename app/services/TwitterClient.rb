class TwitterClient
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key    = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.bearer_token    = ENV["TWITTER_BEARER_TOKEN"]
    end
  end

  attr_reader :client

  # Recursive call to Twitter API
  # Source: https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

  def get_all_tweets(twitter_handle)
    Rails.cache.fetch(twitter_handle, expires_in: 15.minutes) do
      collect_with_max_id do |max_id|
        options = {count: 200, include_rts: false}
        options[:max_id] = max_id unless max_id.nil?
        @client.user_timeline(twitter_handle, options)
      end
    end
  end

  def verify_account(twitter_handle)
    begin
      p @c.user(twitter_handle)
      true
    rescue Twitter::Error => e
      p "Error: #{e}"
      false
    end
  end
end

# # Deprecated helper functions
# def retrieve_tweets(twitter_handle)
#     @c.user_timeline(twitter_handle, {count: 200})
# end
