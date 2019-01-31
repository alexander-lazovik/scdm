Rails.application.routes.draw do

  get 'errors/not_found'
  get 'errors/internal_server_error'

  resource :portal_user, shallow: true, only: [:show, :edit] do
    resources :messages, controller: 'portal_users/messages', only: [:index]

    member do
      patch :update_email
      patch :update_password
    end
  end

  constraints(id: /[^\/]+/) do
    resources :web_portal_routes, only: [:show] do
      member { get :rdl }
    end
    resources :draw_and_returns, controller: 'web_portal_routes/location_draw_returns', only: [:edit, :update]
    resources :print_draw_and_returns, controller: 'web_portal_routes/print_draw_returns', only: [:show]
    resources :rdl_draw_and_returns, controller: 'web_portal_routes/rdl_draw_returns', only: [:edit, :update]
  end

  root to: 'login#new'
  get    '/login',   to: 'login#new'
  post   '/login',   to: 'login#create'
  delete '/logout',  to: 'login#destroy'

  resources :forgot_passwords, only: [:new, :create]

  mount AppStatus::Engine => "/status"

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  resources :miscpages, only:[:show] do
    get "/miscpages/:page" => "miscpages#show"
  end
end

