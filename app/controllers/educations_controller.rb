class EducationsController < ApplicationController
  before_action :set_education, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :authenticate_user!

  include EducationsHelper

  # GET /educations
  # GET /educations.json
  def index
    @educations = Education.all
  end

  # GET /educations/1
  # GET /educations/1.json
  def show
  end

  # GET /educations/new
  def new
    @education = @user.educations.build
    prepare_view_content
  end
  
  def new_auto
    @education = @user.current_education.dup
    
    #increase year by 1
    @education.year += 1 if @education.year
    
    #increase semester only semester exists
    if @education.semester
      semester = Semester.find_by_no(@education.semester.no + 1)
      if semester 
        @education.semester = semester
      else
        #increase uni_year if necessary
        uni_year = UniYear.find_by_no(@education.uni_year.no + 1)
        if uni_year
          @education.uni_year = uni_year
          @education.semester = uni_year.semesters.find_by_no(1)
        end
      end
    end
    
    @education.save
    @isEditable = true
    
    respond_to do |format|
      format.js
    end
  end
  
  # GET /educations/1/edit
  def edit
    prepare_view_content
  end

  # POST /educations
  # POST /educations.json
  def create
    @education = Education.new(education_params)
    @isEditable = true

    respond_to do |format|
      if @education.save
        format.html
        format.js
        format.json { render action: 'show', status: :created, location: @education }
      else
        format.html
        format.json { render json: @education.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /educations/1
  # PATCH/PUT /educations/1.json
  def update
    @isEditable = true

    respond_to do |format|
      if @education.update(education_params)
        format.html 
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @education.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /educations/1
  # DELETE /educations/1.json
  def destroy
    @education.destroy
    @isEditable = true
    
    if !params[:new_education_id].blank?
      @user.current_education = Education.find(params[:new_education_id].to_i)
      @user.save!
    end
    
    respond_to do |format|
      format.html
      format.js
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_education
      @education = Education.find(params[:id])
    end
    
    def set_user
      @user = User.find(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def education_params
      params.permit(:user_id, :university_id, :faculty_id, :new_education_id)
      params.require(:education).permit(:uni_year_id, :semester_id, :year, :university_id, :faculty_id, :course_id, :user_id)
    end
end