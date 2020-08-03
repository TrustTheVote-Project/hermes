Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :voters, only: [:index, :show] do
    put 'import', on: :collection
  end
end
