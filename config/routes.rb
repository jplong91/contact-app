Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  post "/users" => "users#create"

  get "/contacts" => "contacts#index"
  get "/contacts/:id" => "contacts#show"
  post "/contacts" => "contacts#create"
  delete "/contacts/:id" => "contacts#destroy"
  patch "/contacts/:id" => "contacts#update"
end
