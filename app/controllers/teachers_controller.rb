class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource only: [:show, :new, :edit, :destroy] # index action is authorized a bit different
  
  include TeachersHelper


  # GET /teachers
  # GET /teachers.json
  def index
    # get teachers from current university ( in subdomain )
    @teachers = current_university.teachers
    authorize! :index, @teachers
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
    @teacher = Teacher.new
    prepare_view_content
  end

  # GET /teachers/1/edit
  def edit
    prepare_view_content
  end

  # POST /teachers
  # POST /teachers.json
  def create
    prepare_view_content

    @teacher = current_university.teachers.new(teacher_params)
    @teacher.subjects = current_university.subjects.where(id: params[:teacher][:subjects])

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
    prepare_view_content
    
    #add subjects
    @teacher.subjects = current_university.subjects.where(id: params[:teacher][:subjects])
    
    #delete image
    #present? is equivalent to !blank?
    if params[:remove_picture].present? && params[:remove_picture].to_i == 1
      if @teacher.picture.present? 
        @teacher.picture.destroy
      end
    end
    
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
    @teacher.destroy
    
    respond_to do |format|
      format.html { redirect_to :teachers }
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
      params.require(:teacher).permit(:first_name, :first_name_kana, :first_name_kanji, :last_name, :last_name_kana, :last_name_kanji, :title, :info, :faculty_id, :lab, :lab_url, :email, :picture)
    end
end
