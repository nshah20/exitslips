Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get "sign_in", to: "sessions#new"
  end

  get "/sections/:section_id/quizzes/:id", to: "quizzes#results"
  get "/sections/:section_id/quizzes/:id/groups", to: "quizzes#groups"

  root to: 'home#index'

  resources :quizzes do
    resources :sittings, only: [:new, :create]
  end
  post "/sections/add_section" => "sections#add_section", as: "add_section"

  get "/sections/show_bargraph" => "sections#show_bargraph", as: "show_bargraph"

  resources :sections
  resources :users, except: [:index]


  resources :standards, only: [:index], :defaults => { :format => 'json' }

  get "/quizzes/:id/finished_quiz" => "quizzes#finish", as: "quizzes_finish"


end
