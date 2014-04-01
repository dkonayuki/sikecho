class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy, :inline, :version]
  before_action :set_course, only: [:index, :new, :create]
  impressionist actions: [:show]

  include SubjectsHelper
  
  # GET /subjects
  # GET /subjects.json
  def index
    @user = current_user
    
    #custom show
    @show_semester = true
    @show_notice = true
    
    if !params[:page].blank?
      @show_more = true
    end
    
    if params[:filter].blank?
      #all
      @subjects = @course.subjects
    else
      #filter tag
      case params[:filter]
      when '全学年'
        @subjects = @course.subjects
      when '学年別'
        #filter semester
        semester = Semester.find(params[:semester].to_i)
        #filter from user's university
        @subjects = @course.subjects.where(semester: semester)
      else
        #default: filter with tag
        @subjects = @course.subjects.tagged_with(params[:filter])
      end
    end
    
    if !params[:style].blank?
      @user.settings(:subject).style = params[:style].to_sym
      @user.save
    end
    
    #reorder subjects list
    case @user.settings(:subject).style
    when :all
      @subjects = @subjects.order('year DESC, view_count DESC')
    when :semester
      @subjects = @subjects.joins(:semester).joins(:uni_year).order('uni_years.no ASC, semesters.no ASC')
    when :note_count
      @subjects = @subjects.order('notes_count DESC')
      #@subjects = @subjects.joins(:notes).group('notes_subjects.subject_id').order('COUNT(notes_subjects.subject_id) DESC')
      #Topic.includes(:questions).group('questions_topics.topic_id').references(:questions).order("count(questions_topics.topic_id) DESC")
    end
    
    #search subjects list
    @subjects = @subjects.search(params[:search])
    #paginate @subjects
    @subjects = @subjects.page(params[:page]).per(12)
    
    #respond with js format, index.js.erb will be run
    respond_to do |format|
      format.html {}
      format.js   {}
      format.json { render json: @subjects, status: :ok }
    end
  end
  
  # GET /subjects/1
  # GET /subjects/1.json
  def show
    if !params[:tag].blank?
      #filter in show subject page
      @notes = @subject.notes.tagged_with(params[:tag])
    else
      @notes = @subject.notes
    end
    
    #order by view count
    @notes = @notes.order('view_count DESC')
    
    # notes will not show subject name
    @show_subject = false
    
    # same subjects, need to change later
    @same_subjects = @subject.course.subjects.where(name: @subject.name).order('year DESC')
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
    @subject = @course.subjects.build

    prepare_view_content
  end

  # GET /subjects/1/edit
  def edit
    prepare_view_content
  end

  # POST /subjects
  # POST /subjects.json
  def create
    #prepare previous info
    prepare_view_content
    
    #create new subject
    @subject = @course.subjects.new(subject_params)
    @subject.teachers = @user.university.teachers.where(id: params[:teachers])
    
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
    if !params[:tag].blank?
      #filter in show subject page
      @notes = @subject.notes.tagged_with(params[:tag])
    else
      @notes = @subject.notes
    end
    # notes will not show subject name
    @show_subject = false
    @same_subjects = @subject.course.subjects.where(name: @subject.name)
    respond_to do |format|
      format.html { render action: 'show' }
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    #prepare previous info
    prepare_view_content
    
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
      format.html { redirect_to course_subjects_path(@subject.course) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end
    
    def set_course
      @course = Course.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.permit(:name, :pk, :value, :tag, :filter, :semester, :uni_year_id, :teachers, :old_number, :version_id, :course_id, :page, :style)
      params.require(:subject).permit(:name, :description, :year, :place, :number_of_outlines, :semester_id, :uni_year_id, :course_id, periods_attributes: [:id, :time, :day, :_destroy])
    end
end
