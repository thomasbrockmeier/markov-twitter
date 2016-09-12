class AddNParagraphsToMarkovChainers < ActiveRecord::Migration[5.0]
  def change
    add_column :markov_chainers, :n_paragraphs, :integer
  end
end
