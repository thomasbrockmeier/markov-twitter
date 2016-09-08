class CreateMarkovChainers < ActiveRecord::Migration[5.0]
  def change
    create_table :markov_chainers do |t|
      t.text :input_text
      t.integer :order
      t.integer :n_sentences

      t.timestamps
    end
  end
end
