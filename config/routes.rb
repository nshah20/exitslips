Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get "sign_in", to: "sessions#new"
  end

  root to: 'home#index'

  resources :quizzes
  resources :sections
  resources :users, except: [:index]

  get '/teacher/quizzes' => "quizzes#index_teacher", as: "quizzes_index"


  # resources :teachers
  # resources :students, except: [:index]
  # resources :sections do
  #   resources :quizzes
  #   resources :students
  # end
  # get "/quizzes" => "quizzes#index", as: "quizzes"

end


