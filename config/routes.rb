Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope "(:locale)", locale: /en|fr/ do
    root "pages#home"
    get "about",        to: "pages#about"
    get "services",     to: "pages#services"
    get "destinations", to: "pages#destinations"
    get "how-it-works", to: "pages#how_it_works"
    get "faq",          to: "pages#faq"
    get "contact",      to: "pages#contact"
    get "track",        to: "pages#track"
end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
