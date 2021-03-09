Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  get 'similar_movies/:id', to: 'movies#search', as: 'search_similar_movies'
end
