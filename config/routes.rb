Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"
  resources :timesheets, only: %i[index new create show destroy] do
    scope module: "timesheets" do
      resources :line_items, only: %i[new create edit update]
    end
  end

  scope module: "users" do
    resource :configurations, only: %i[edit update]
  end

  get "onboard", to: "onboarding#onboard", as: :user_root
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
