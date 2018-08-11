Rails.application.routes.draw do
  scope "/api", defaults: { format: :json } do
    post :sign_in, to: "session#create"
    post :sign_up, to: "registration#create"
    resources :users, except: %i[new edit]
  end
end
