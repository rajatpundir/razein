class ObjectiveQuestionsController < ApplicationController

	before_action :confirm_logged_in
	before_action :is_not_regular

	# READ ACTIONS
	def index
		@objective_test = ObjectiveTest.find(params[:objective_test_id])
		############################################################
		############SECURITY#########CHECK##########################
		if @objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
		@objective_test_id = @objective_test.id
		@objective_questions = @objective_test.objective_questions.order('objective_questions.created_at DESC')
	end

	def show
		@objective_question = ObjectiveQuestion.find(params[:id])
		############################################################
		############SECURITY#########CHECK##########################
		if @objective_question.objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
	end

	def add_wrong_answer
		@objective_question = ObjectiveQuestion.find(params[:objective_question_id])
		############################################################
		############SECURITY#########CHECK##########################
		if @objective_question.objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
		@wrong_answer = WrongAnswer.new(:message => params[:wrong_answer][:message], :objective_question_id => @objective_question.id)
		if @wrong_answer.save
			redirect_to edit_objective_question_path(@objective_question.id)
		else
			flash[:danger].now = "Wrong Answer couldn't be created."
			render 'new'
		end
	end

	def delete_wrong_answer
		@wrong_answer = WrongAnswer.find(params[:format])
		############################################################
		############SECURITY#########CHECK##########################
		if @wrong_answer.objective_question.objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
		@wrong_answer.destroy
		flash[:success] = "Wrong Answer deleted successfully."
		redirect_to edit_objective_question_path(@wrong_answer.objective_question)
	end

	# CREATE ACTIONS
	def new
		@objective_test = ObjectiveTest.find(params[:objective_test_id])
		############################################################
		############SECURITY#########CHECK##########################
		if @objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
		@objective_test_id = @objective_test.id
		@objective_question = ObjectiveQuestion.new
	end

	def create
		@objective_test = ObjectiveTest.find(params[:objective_test_id])
		############################################################
		############SECURITY#########CHECK##########################
		if @objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
		@objective_question = ObjectiveQuestion.new(:answer => params[:objective_question][:answer], :message => params[:objective_question][:message], :objective_test_id => @objective_test.id, :origin => session[:username])
		if @objective_question.save
			flash[:success] = "Question created successfully"
			redirect_to objective_questions_path(objective_test_id: @objective_test.id)
		else
			flash[:danger].now = "Question couldn't be created."
			render 'new'
		end
	end

	# UPDATE ACTIONS
	def edit
		@objective_question = ObjectiveQuestion.find(params[:id])
		############################################################
		############SECURITY#########CHECK##########################
		if @objective_question.objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
		@objective_test_id = @objective_question.objective_test.id
		@wrong_answer = WrongAnswer.new
	end

	def update
		@objective_question = ObjectiveQuestion.find(params[:id])
		############################################################
		############SECURITY#########CHECK##########################
		if @objective_question.objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
		if @objective_question.update_attributes(objective_question_params)
			redirect_to objective_questions_path(objective_test_id: @objective_question.objective_test.id)
		else
			render 'edit'
		end
	end

	# DELETE ACTIONS
	def delete
		@objective_question = ObjectiveQuestion.find(params[:id])
		############################################################
		############SECURITY#########CHECK##########################
		if @objective_question.objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
		@objective_test_id = @objective_question.objective_test.id
	end

	def destroy
		@objective_question = ObjectiveQuestion.find(params[:id])
		############################################################
		############SECURITY#########CHECK##########################
		if @objective_question.objective_test.floor.tower.id != session[:tower_id]
			redirect_to floors_path
			return
		end
		############################################################
		############################################################
		@objective_question.destroy
		flash[:success] = "Question '#{@objective_question.id}' deleted successfully."
		redirect_to objective_questions_path(objective_test_id: @objective_question.objective_test.id)
	end

	private

	def objective_question_params
		params.require(:objective_question).permit(:message, :answer)
	end

end
