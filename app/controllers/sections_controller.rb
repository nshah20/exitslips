class SectionsController < ApplicationController
	include SectionsHelper

	before_action :authenticate_user!

	def index
    if @student = current_student
      @sections = @student.sections.includes(:teacher)
      render 'index_student'
    elsif @teacher = current_teacher
  	  respond_to do |format|
  	  	format.json {
  			  render json: current_teacher.mastery_by_section
  	  	}
  	  	format.html{
  	  		@teacher = current_teacher
  			  @sections = @teacher.sections
  			  @mastery = @teacher.mastery_for_all_sections
  	  	}
      end
    end
	end

	def show_bargraph
		respond_to do |format|
			format.json {
				render plain: "hello world"
			}
		end
	end

	def show
    @section = Section.includes(:quizzes, :requirements).find(params[:id])
    @quizzes = @section.quizzes

    if @student = current_student
      @teacher = @section.teacher
      render 'show_student'
    elsif current_teacher
      respond_to do |format|
        format.json {
          render json: @section.calculate_scores_by_standard
        }
        format.html {
          @students = @section.students
          @standards = @section.standards.sort_by { |s| s.id }
          @quizzes = @section.quizzes
        }
        format.csv {
          send_data @section.to_csv
        }
      end
		end
	end

  def new
	 	@section = Section.new
		@teacher = current_user

	  render :layout => false
	end

	def create
		@section = Section.create!(section_params)
		@section.teacher_id = current_user.id
		if request.xhr? && @section.save!
			render json: {section: @section.name, id: @section.id}
		else
			redirect_to sections_path
		end
	end


	def edit
	  @section = Section.find(params[:id])
	end

	def update
		@section = Section.find(params[:id])
		@section.update(section_params)
		if @section.save
			redirect_to section_path(@section)
    else
    	render 'edit'
    end
	end

	def destroy

		@section = Section.find(params[:id])

		 if @section.destroy
		 	redirect_to sections_path
		 else
		 	redirect_to sections_path
		 end
	end

	def add_section
		passcode = params[:add_section].values[0]
		section = Section.find_by(passcode: passcode)
		if section == nil
			# add error message
			redirect_to quizzes_path
		else
			Enrollment.create(section_id: section.id, student_id: current_user_id)
			redirect_to quizzes_path
		end
	end

	private
    def section_params
    	params.require(:section).permit(:name,:subject,:grade)
    end
end
