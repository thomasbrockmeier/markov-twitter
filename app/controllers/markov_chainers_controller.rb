class MarkovChainersController < ApplicationController

  def index
    @markov ||= MarkovChainer.new
  end

  def create
    # binding.pry

    @markov ||= MarkovChainer.new(markov_chainer_params)

    respond_to do |format|
      if response_string = @markov.process_twitter_account
        format.html {
          # flash[:input_text] = response_string
          # redirect_to root_path
        }
        format.json {
          render json: response_string.to_json
        }
      else
        format.json {
          render json: "ERROR"
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
