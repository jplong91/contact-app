Rails.application.routes.draw do
  get "/eric" => "contacts#eric"
  get "/megan" => "contacts#megan"
  get "/scott" => "contacts#scott"
  get "/everyone" => "contacts#everyone"
end
