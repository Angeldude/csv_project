Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'csv_processing#index'

  post '/create' => 'csv_processing#create', as: :csv_files

end
