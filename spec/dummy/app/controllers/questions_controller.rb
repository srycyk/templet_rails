
class QuestionsController < ApplicationController
  include Templet::ViewerResponders

  before_action :set_category

  before_action :set_question, only: %i(show edit update destroy)

  # GET /categories/1/questions
  # GET /categories/1/questions.json
  def index
    @questions = @category.questions.all

    respond_to_index
  end

  # GET /categories/1/questions/1
  # GET /categories/1/questions/1.json
  def show
    respond_to_show
  end

  # GET /categories/1/questions/new
  def new
    @question = @category.questions.new

    respond_to_new
  end

  # GET /categories/1/questions/1/edit
  def edit
    respond_to_edit
  end

  # POST /categories/1/questions/1
  # POST /categories/1/questions/1.json
  def create
    @question = @category.questions.new(question_params)

    if @question.save
      respond_to_save_success(@question, [@category, @question])
    else
      respond_to_save_failure(:new, @question)
    end
  end

  # PATCH/PUT /categories/1/questions/1
  # PATCH/PUT /categories/1/questions/1.json
  def update
    if @question.update(question_params)
      respond_to_save_success(@question, [@category, @question])
    else
      respond_to_save_failure(:edit, @question)
    end
  end

  # DELETE /categories/1/questions/1
  # DELETE /categories/1/questions/1.json
  def destroy
    @question.destroy

    respond_to_destroy(@question, [@category, :questions])
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def set_question
    @question = @category.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(*question_fields)
  end

  def question_fields
    %i(query active expires_on category_id)
  end

  def viewer_options
    super.merge({ parent: :category })
  end
end
