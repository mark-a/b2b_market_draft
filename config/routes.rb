Rails.application.routes.draw do
  namespace :admin do
    resources :notifications
    resources :announcements
    resources :members

    root to: "notifications#index"
  end

  scope "(:locale)", locale: /en|es|de/ do
    devise_for :members

    resources :notifications, only: [:index]
    resources :announcements, only: [:index]

    get "/" => "landing_page#index", as: :locale_root

    resources :company_profiles
    resources :companies

    resources :search, only: [:index], path: '/search/'
    resources :provider_search, only: [:show], path: '/search/providers/'
    resources :purchaser_search, only: [:show], path: '/search/purchasers/'
    post "/search/providers/:id", to: "provider_search#show"
    post "/search/purchasers/:id", to: "purchaser_search#show"
    get "/search/criterium/:criterium_id", to: "search#criteria_values"

    post "/company/provide/", to: "criteria_upload#add_provider", as: "add_provider"
    post "/company/purchase/", to: "criteria_upload#add_purchaser", as: "add_purchaser"

    get "/privacy", to: 'landing_page#privacy'
    get "/terms", to: 'landing_page#terms'
  end

  get "/company_profiles/:id/image", to: "company_profiles#image", as: "company_profiles_image"

  post "/sudo", to: "landing_page#make_me_admin" if Rails.env.development?

  root "landing_page#index"
end
