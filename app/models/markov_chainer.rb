require 'TwitterClient'

class MarkovChainer < ApplicationRecord
  after_initialize :init

  def init
    self.input_text ||= ''
    self.order ||= 2
    self.n_sentences ||= 5

    @c ||= TwitterClient.new.client
  end


  def process_twitter_account
    begin
      p "Getting tweets"
      tweets = get_all_tweets(self.input_text)
      p "Got tweets"
      filtered_text = filter_text(extract_text(tweets))

      markov = MarkyMarkov::Dictionary.new('dictionary', self.order)
      markov.parse_string(filtered_text)
      markov.generate_n_sentences n_sentences
    rescue Twitter::Error => e
      p "Error: #{e}"
      e
    end
  end



  # Recursive call to Twitter API
  # Source: https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

  def get_all_tweets(twitter_handle)
    collect_with_max_id do |max_id|
      options = {count: 200, include_rts: false}
      options[:max_id] = max_id unless max_id.nil?
      @c.user_timeline(twitter_handle, options)
    end
  end



  # Helper functions
  def extract_text(tweets)
    text = ''
    tweets.each do |t|
      text << (t::text) + ' '
    end

    text
  end

  def filter_text(text)
    # Remove hashtags, handlers, and URLs (#hashtag, @kanyewest, http(s)://..., www....)
    text.gsub(/(#\S*|@\S*|http(|s):\/\/\S*|www.\S*)/i, '')
  end
end

  # # Deprecated helper functions
  # def retrieve_tweets(twitter_handle)
  #     @c.user_timeline(twitter_handle, {count: 200})
  # end
  #
  # def verify_account(twitter_handle)
  #   begin
  #     p @c.user(twitter_handle)
  #     [true]
  #   rescue Twitter::Error => e
  #     p "Error: #{e}"
  #     [false, e]
  #   end
  # end



#   # Testing functions
#   # Used to process whatever text is enterend on the view. Used for testing
#   # purposes
#   def process_input
#     markov = MarkyMarkov::Dictionary.new('dictionary', self.order)
#     markov.parse_string(self.input_text)
#     markov.generate_n_sentences n_sentences
#   end
