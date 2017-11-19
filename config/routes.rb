Rails.application.routes.draw do
  get "/contacts" => "contacts#index"
  get "/contacts/:id" => "contacts#show"
  post "/contacts" => "contacts#create"
  delete "/contacts/:id" => "contacts#destroy"
  patch "/contacts/:id" => "contacts#update"
end
