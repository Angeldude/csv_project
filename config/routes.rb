Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'csv_processing#input'

  post '/' => 'csv_processing#create_or_update', as: :csv_files

  patch '/' => 'csv_processing#create_or_update', as: :csv_file

  get '/input' => 'csv_processing#input'
  get '/output' => 'csv_processing#output'

  post '/output' => 'csv_processing#search', as: :search

end
