class MarkovChainersController < ApplicationController
  def index
    @markov ||= MarkovChainer.new
  end

  def create
    @markov = MarkovChainer.new(markov_chainer_params)

    flash[:input_text] = @markov.process_input
    flash[:order] = @markov[:order]
    flash[:n_sentences] = @markov[:n_sentences]

    redirect_to root_path
  end


  private

  def markov_chainer_params
    params.require(:markov_chainer).permit(
      :input_text,
      :order,
      :n_sentences
    )
  end
end
