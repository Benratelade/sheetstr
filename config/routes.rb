Rails.application.routes.draw do
  devise_for :users, :timesheets

  resources :timesheets, only: %i[new]

  get "timesheet", to: "timesheets#new", as: :user_root
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
