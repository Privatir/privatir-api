Rails.application.routes.draw do
  scope '/api' do
    get '/status', controller: :status, action: :index
    post '/newsletter/subscribe', controller: :newsletter_subscribe, action: :index
    post   '/refresh', controller: :refresh, action: :create
    post   '/signup',  controller: :signup,  action: :create
    post   '/signin',  controller: :signin,  action: :create
    delete '/signin',  controller: :signin,  action: :destroy
  end
  get '*path', to: 'application#fallback_index_html', constraints: lambda { |request|
    !request.xhr? && request.format.html?
  }
end
