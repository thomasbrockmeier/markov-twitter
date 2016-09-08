class MarkovChainersController < ApplicationController
  def index
    @markov ||= MarkovChainer.new
  end
end
