Rails.application.routes.draw do
  resources :voters do
    post 'import', on: :collection
  end
end
