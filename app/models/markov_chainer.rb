require 'TwitterClient'

class MarkovChainer < ApplicationRecord
  after_initialize :init

  def init
    self.input_text ||= ''
    self.order ||= 2
    self.n_sentences ||= 5
  end

  def process_input
    markov = MarkyMarkov::Dictionary.new('dictionary', self.order)
    markov.parse_string(self.input_text)
    markov.generate_n_sentences n_sentences
  end

  def process_twitter_account
    tweets = retrieve_tweets(self.input_text)
    text = extract_text(tweets)
    filtered_text = filter_text(text)

    markov = MarkyMarkov::Dictionary.new('dictionary', self.order)
    markov.parse_string(filtered_text)
    markov.generate_n_sentences n_sentences

  end

  def retrieve_tweets(twitter_handle)
    c = TwitterClient.new.client
    tweets = c.user_timeline(twitter_handle, {count: 200})
  end

  def extract_text(tweets)
    text = ''
    tweets.each do |t|
      text << (t::text) + ' '
    end

    text
  end

  def filter_text(text)
    # Remove hashtags, handlers, and URLs (#hashtag, @kanyewest, http(s)://...)
     processed_text = text.gsub(/(#\S*|@\S*|http(|s):\/\/\S*|www.\S*)/i, '')
  end
end
