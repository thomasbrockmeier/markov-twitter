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
end
