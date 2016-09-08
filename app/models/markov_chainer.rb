class MarkovChainer < ApplicationRecord
  after_initialize :init

  def init
    self.input_text ||= ''
    self.order ||= 2
    self.n_sentences ||= 5
  end
end
