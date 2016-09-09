class MarkovChainersController < ApplicationController

  def index
    @markov ||= MarkovChainer.new
  end

  def create
    # binding.pry

    p 'markov_chainer_params'
    p markov_chainer_params

    @markov = MarkovChainer.new(markov_chainer_params)

    p @markov.process_twitter_account

    respond_to do |format|
      if response_string = @markov.process_twitter_account
        format.html {
          # flash[:input_text] = response_string
          # redirect_to root_path
        }
        format.json {
          p 'render json'
          render json: response_string.to_json
        }
      end



    end
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
