Rails.application.routes.draw do
  get    '/status',  controller: :status,  action: :index
  post   '/refresh', controller: :refresh, action: :create
  post   '/signup',  controller: :signup,  action: :create
  post   '/signin',  controller: :signin,  action: :create
  delete '/signin',  controller: :signin,  action: :destroy
end
