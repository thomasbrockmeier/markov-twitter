Rails.application.routes.draw do
  root 'markov_chainers#index'
  post '/markov_chainers', to: 'markov_chainers#create'
end
