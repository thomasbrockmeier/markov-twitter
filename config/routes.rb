Rails.application.routes.draw do
  root 'markov_chainers#index'
  post '/markov_chainers', to: 'markov_chainers#create'
  get '/markov_chainers/show', to: 'markov_chainers#show'
end
