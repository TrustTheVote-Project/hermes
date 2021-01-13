Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :healthz, only: [:index]
  resources :voters, only: [:index, :show, :update] do
    put 'import', on: :collection
  end
end
