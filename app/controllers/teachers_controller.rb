class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index, :show, :new, :edit, :destroy]

  # GET /teachers
  # GET /teachers.json
  def index
    # TODO
    @teachers = Teacher.all
  end

  # GET /teachers/1
  # GET /teachers/1.json
  def show
    @subjects = @teacher.subjects
    
    # create hash of arrays from array by using group_by
    @subjects_by_year = @subjects.group_by { |subject| subject.year }
  end

  # GET /teachers/new
  def new
    # TODO
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
    # TODO
  end

  # POST /teachers
  # POST /teachers.json
  def create
    # TODO
    @teacher = Teacher.new(teacher_params)

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to @teacher, notice: 'Teacher was successfully created.' }
        format.json { render action: 'show', status: :created, location: @teacher }
      else
        format.html { render action: 'new' }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachers/1
  # PATCH/PUT /teachers/1.json
  def update
    # TODO
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to @teacher, notice: 'Teacher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1
  # DELETE /teachers/1.json
  def destroy
    # TODO
    @teacher.destroy
    
    respond_to do |format|
      format.html { redirect_to teachers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      # only show teacher page belongs to appropriate subdomain/university
      @teacher = current_university.teachers.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit(:first_name, :first_name_kana, :last_name, :last_name_kana, :role, :university_id, :faculty_id)
    end
end
