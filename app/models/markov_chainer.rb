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
    response = verify_account(self.input_text)

    if response[0]
      filtered_text = filter_text(extract_text(retrieve_tweets(self.input_text)))

      markov = MarkyMarkov::Dictionary.new('dictionary', self.order)
      markov.parse_string(filtered_text)
      markov.generate_n_sentences n_sentences
    else
      response[1]
    end
  end

  def verify_account(twitter_handle)
    begin
      p @c.user(twitter_handle)
      [true]
    rescue Twitter::Error => e
      p "Error: #{e}"
      [false, e]
    end
  end

  def retrieve_tweets(twitter_handle)
      @c.user_timeline(twitter_handle, {count: 200})
  end

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





  # Used to process whatever text is enterend on the view. Used for testing puropses
  def process_input
    markov = MarkyMarkov::Dictionary.new('dictionary', self.order)
    markov.parse_string(self.input_text)
    markov.generate_n_sentences n_sentences
  end
end
