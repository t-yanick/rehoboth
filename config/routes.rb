Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Staff sign in, two-step code, password reset
  resource :session
  resource :two_factor_session, only: %i[new create]
  resources :passwords, param: :token

  # Staff area
  namespace :admin do
    root "dashboard#show"
    resource :two_factor, only: %i[show new create destroy]
    resources :users, except: %i[show destroy] do
      patch :reset_two_factor, on: :member
    end
  end

  # Public website (EN/FR)
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
end
