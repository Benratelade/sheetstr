Rails.application.routes.draw do
  devise_for :users, :timesheets

  root to: "pages#home"
  resources :timesheets, only: %i[index new create show] do
    scope module: "timesheets" do
      resources :line_items, only: %i[new create]
    end
  end

  get "timesheet", to: "timesheets#new", as: :user_root
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
