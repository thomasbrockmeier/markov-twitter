require_relative '../services/TwitterClient'

class MarkovChainer < ApplicationRecord
  after_initialize :init

  def init
    self.input_text ||= ''
    self.order ||= 2
    self.n_paragraphs ||= 3
    self.n_sentences ||= 5

    @c ||= TwitterClient.new
  end


  def process_twitter_account
    begin
      p "Getting tweets"
      tweets = @c.get_all_tweets(self.input_text)
      p "Got tweets"
      filtered_text = filter_text(extract_text(tweets))

      markov = MarkyMarkov::Dictionary.new('dictionary', self.order)
      markov.parse_string(filtered_text)

      generate_paragraphs(markov, self.n_paragraphs, self.n_sentences)

    rescue Twitter::Error => e
      p "Error: #{e}"
      e
    end
  end


  private
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

  def generate_paragraphs(markov, n_paragraphs, n_sentences)
    output = ''
    (0...n_paragraphs).each do |p|
      output << "<p id=\"paragraph_id=#{p}\">#{markov.generate_n_sentences n_sentences}</p>"
    end
    output
  end
end


#   # Testing functions
#   # Used to process whatever text is enterend on the view. Used for testing
#   # purposes
#   def process_input
#     markov = MarkyMarkov::Dictionary.new('dictionary', self.order)
#     markov.parse_string(self.input_text)
#     markov.generate_n_sentences n_sentences
#   end
