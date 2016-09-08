class MarkovChainersController < ApplicationController
  def index
    @markov ||= MarkovChainer.new
  end

  def create
    @markov = MarkovChainer.new(markov_chainer_params)

    session[:input_text] = markov_chainer_params[:input_text]
    session[:order] = markov_chainer_params[:order]
    session[:n_sentences] = markov_chainer_params[:n_sentences]

    redirect_to root_path
  end

  def show(markov)
    @markov
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
