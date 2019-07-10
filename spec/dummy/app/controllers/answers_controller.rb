
class AnswersController < ApplicationController
  include Templet::ViewerResponders

  before_action :set_question

  before_action :set_answer, only: %i(show edit update destroy)

  # GET /questions/1/answers
  # GET /questions/1/answers.json
  def index
    @answers = @question.answers.all

    respond_to_index
  end

  # GET /questions/1/answers/1
  # GET /questions/1/answers/1.json
  def show
    respond_to_show
  end

  # GET /questions/1/answers/new
  def new
    @answer = @question.answers.new

    respond_to_new
  end

  # GET /questions/1/answers/1/edit
  def edit
    respond_to_edit
  end

  # POST /questions/1/answers/1
  # POST /questions/1/answers/1.json
  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      respond_to_save_success(@answer, [@question, @answer])
    else
      respond_to_save_failure(:new, @answer)
    end
  end

  # PATCH/PUT /questions/1/answers/1
  # PATCH/PUT /questions/1/answers/1.json
  def update
    if @answer.update(answer_params)
      respond_to_save_success(@answer, [@question, @answer])
    else
      respond_to_save_failure(:edit, @answer)
    end
  end

  # DELETE /questions/1/answers/1
  # DELETE /questions/1/answers/1.json
  def destroy
    @answer.destroy

    respond_to_destroy(@answer, [@question, :answers])
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(*answer_fields)
  end

  def answer_fields
    %i(reply active rating by question_id)
  end

  def viewer_options
    super.merge({ parent: :question, grand_parent: :category })
  end
end
