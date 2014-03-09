class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  
  # GET /subjects
  # GET /subjects.json
  def index
    @user = current_user
    if params[:tag].blank? && params[:semester].blank? && params[:search].blank?
      #all
      @subjects = @user.faculty.subjects.to_a
    elsif !params[:search].blank?
      @subjects = @user.faculty.subjects.search(params[:search])
    else
      #filter tag
      if !params[:tag].blank?
        @subjects = @user.faculty.subjects.tagged_with(params[:tag])
      #filter semester
      elsif !params[:semester].blank?
        year = @user.university.uni_years.find_by_no(params[:uni_year].to_i)
        semester = year.semesters.find_by_no(params[:semester].to_i)
        #filter from user's faculty subjects
        #@subjects = @user.faculty.subjects.select { | subject | subject.semester == semester } old version
        @subjects = @user.faculty.subjects.where(semester: semester)
      else
      end
      #respond with js format, index.js.erb will be run
      respond_to do |format|
        format.html {}
        format.js   {}
        format.json { render json: @subjects, status: :ok, location: :subjects }
      end
    end
    #other option: render action: "index"
  end
  
  # GET /subjects/1
  # GET /subjects/1.json
  def show
    @user = current_user
    if !params[:tag].blank?
      #filter in show subject page
      @notes = @subject.notes.tagged_with(params[:tag])
    else
      @notes = @subject.notes
    end
    @show_subject = false
    @same_subjects = @user.faculty.subjects.where(name: @subject.name)
    respond_to do |format|
      format.html {}
      format.js   {}
    end
  end

  def semester
    uni_year = UniYear.find_by_id(params[:uni_year_id])
    @semesters = uni_year ? uni_year.semesters : []
    respond_to do |format|
      format.js { render 'subjects/semester' }
      format.html
      format.json
    end
  end

  # GET /subjects/new
  def new
    @user = current_user
    @subject = Subject.new
    @uni_years = current_user.university.uni_years
    @semesters = []
    @teachers = current_user.university.teachers
    @years = (2012..2015).to_a
    @number_of_outlines_list = (1..15).to_a
  end

  # GET /subjects/1/edit
  def edit
    @user = current_user
    @uni_years = current_user.university.uni_years
    @semesters = []
    @teachers = current_user.university.teachers
    @years = (2012..2015).to_a
    @number_of_outlines_list = (1..15).to_a
  end

  # POST /subjects
  # POST /subjects.json
  def create
    #prepare previous info
    @user = current_user
    @uni_years = current_user.university.uni_years
    @semesters = []
    @teachers = current_user.university.teachers
    @years = (2012..2015).to_a
    @number_of_outlines_list = (1..15).to_a
    
    #create new subject
    @subject = Subject.new(subject_params)
    @subject.teachers = current_user.university.teachers.where(id: params[:teachers])
    @subject.faculties << current_user.faculty
    (1..@subject.number_of_outlines).each do | i |
      outline = Outline.new(number: i)
      @subject.outlines << outline
    end

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Subject was successfully created.' }
        format.json { render action: 'show', status: :created, location: @subject }
      else
        #prepare semester select
        @semesters = @subject.uni_year ? @subject.uni_year.semesters : []
        format.html { render action: 'new' }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
        format.json { render json: @subject, status: :ok } # 204 No Content
      else
        format.html { render action: 'edit' }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.permit(:name, :value, :tag, :semester, :uni_year, :uni_year_id, :teachers)
      params.require(:subject).permit(:name, :description, :year, :place, :number_of_outlines, :semester_id, :uni_year_id)
    end
end
