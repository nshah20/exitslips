class HomeController < ApplicationController
  layout false

  def index
    if user_signed_in? && current_user.class == Teacher
    	redirect_to sections_path
    elsif user_signed_in? && current_user.class == Student
    	redirect_to quizzes_path
    end

  end
end
