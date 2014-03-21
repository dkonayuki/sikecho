class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy, :inline, :version]
  
  # GET /subjects
  # GET /subjects.json
  def index
    @user = current_user
    if params[:filter].blank?
      #all
      @subjects = @user.university.subjects.search(params[:search])
      #define @search
      @search = params[:search]
    else
      #filter tag
      case params[:filter]
      when '全学年'
        @subjects = @user.university.subjects.search(params[:search])
      when '学年別'
        #filter semester
        uni_year = @user.university.uni_years.find_by_no(params[:uni_year].to_i)
        semester = uni_year.semesters.find_by_no(params[:semester].to_i)
        #filter from user's university
        @subjects = @user.university.subjects.search(params[:search]).where(semester: semester)
        #define @uni_year and @semester
        @uni_year = params[:uni_year]
        @semester = params[:semester]
      else
        #default: filter with tag
        @subjects = @user.university.subjects.search(params[:search]).tagged_with(params[:filter])
      end
    end
          
    #reorder subjects list
    @subjects = @subjects.order('year DESC')
    #respond with js format, index.js.erb will be run
    respond_to do |format|
      format.html {}
      format.js   {}
      format.json { render json: @subjects, status: :ok, location: :subjects }
    end
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
    @same_subjects = @user.university.subjects.where(name: @subject.name)
    respond_to do |format|
      format.html 
      format.js   
    end
  end

  # get new semester list when uni_year changes
  def semester
    uni_year = UniYear.find_by_id(params[:uni_year_id])
    @semesters = uni_year ? uni_year.semesters : []
 
    respond_to do |format|
      format.js
      format.html
    end
  end

  # GET /subjects/new
  def new
    @user = current_user
    @subject = Subject.new
    @uni_years = @user.university.uni_years
    @semesters = []
    @teachers = @user.university.teachers
    @years = (Subject.MAX_YEAR_BEGIN..Subject.MAX_YEAR_END).to_a
    @number_of_outlines_list = (1..15).to_a
    @times = 1.upto(Period.MAX_TIME).to_a
    @days = 1.upto(Period.MAX_DAY).to_a
  end

  # GET /subjects/1/edit
  def edit
    @user = current_user
    @uni_years = @user.university.uni_years
    @semesters = @subject.uni_year ? @subject.uni_year.semesters : []    
    @teachers = @user.university.teachers
    @years = (Subject.MAX_YEAR_BEGIN..Subject.MAX_YEAR_END).to_a
    @number_of_outlines_list = (1..15).to_a
    @times = 1.upto(Period.MAX_TIME).to_a
    @days = 1.upto(Period.MAX_DAY).to_a
  end

  # POST /subjects
  # POST /subjects.json
  def create
    #prepare previous info
    @user = current_user
    @uni_years = @user.university.uni_years
    @teachers = @user.university.teachers
    @years = (Subject.MAX_YEAR_BEGIN..Subject.MAX_YEAR_END).to_a
    @number_of_outlines_list = (1..15).to_a
    @times = 1.upto(Period.MAX_TIME).to_a
    @days = 1.upto(Period.MAX_DAY).to_a
    
    #create new subject
    @subject = Subject.new(subject_params)
    @subject.teachers = @user.university.teachers.where(id: params[:teachers])
    @subject.university = @user.university
    
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
  
  #inline in syllabus
  def inline
    # for inline edit
    case params[:name].to_s
    when 'date'
      #search in array 
      outline = @subject.outlines.find_by_number(params[:pk])
      outline.date = DateTime.strptime(params[:value], '%Y-%m-%d') unless params[:value].blank?
      outline.save
    when 'content'
      #search in array 
      outline = @subject.outlines.find_by_number(params[:pk])
      outline.content = params[:value]
      outline.save
    else
      #no implement
    end
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
  
  #display version
  def version
    #revert to previous version
    @subject = @subject.versions.find(params[:version_id]).reify
    
    #prepare show information
    @user = current_user
    if !params[:tag].blank?
      #filter in show subject page
      @notes = @subject.notes.tagged_with(params[:tag])
    else
      @notes = @subject.notes
    end
    @show_subject = false
    @same_subjects = @user.university.subjects.where(name: @subject.name)
    respond_to do |format|
      format.html { render action: 'show' }
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    #prepare previous info
    @user = current_user
    @uni_years = @user.university.uni_years
    @teachers = @user.university.teachers
    @years = (Subject.MAX_YEAR_BEGIN..Subject.MAX_YEAR_END).to_a
    @number_of_outlines_list = (1..15).to_a
    @times = 1.upto(Period.MAX_TIME).to_a
    @days = 1.upto(Period.MAX_DAY).to_a
    
    #add teachers
    @subject.teachers = @user.university.teachers.where(id: params[:teachers])
    
    #add outlines
    new_number = subject_params[:number_of_outlines].to_i
    old_number = params[:old_number].to_i
    if old_number > new_number
      #delete old outlines
      @subject.outlines.where('number > ?', new_number).destroy_all
    else
      #add new outlines
      old_number = old_number + 1
      (old_number..new_number).each do | i |
        outline = Outline.new(number: i)
        @subject.outlines << outline
      end
    end
    
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
        format.json { render json: @subject, status: :ok } # 204 No Content
      else
        #prepare semester select
        @semesters = @subject.uni_year ? @subject.uni_year.semesters : []
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
      params.permit(:name, :pk, :value, :tag, :filter, :semester, :uni_year, :uni_year_id, :teachers, :old_number, :version_id)
      params.require(:subject).permit(:name, :description, :year, :place, :number_of_outlines, :semester_id, :uni_year_id, periods_attributes: [:id, :time, :day, :_destroy])
    end
end
