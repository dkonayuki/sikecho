class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy, :inline, :version, :outline, :tags]
  
  # monitor view count
  impressionist actions: [:show]

  include SubjectsHelper
  
  # GET /subjects
  # GET /subjects.json
  def index
    @university = current_university
    
    #if next url exists -> param page will exist
    if !params[:page].blank?
      @show_more = true
    end

    #all
    @subjects = @university.subjects
    
    #all filter options use OR  
    if !params[:courses].blank?
      #get courses
      courses = Course.where(id: params[:courses])
      #filter
      @subjects = @subjects.where(course: courses)
    end
    
    if !params[:semesters].blank?
      #get semesters
      semesters = Semester.where(id: params[:semesters])
      #filter
      @subjects = @subjects.where(semester: semesters)    
    end
    
    if !params[:tags].blank?
      #filter tag
      #@subjects = @subjects.tagged_with(params[:tags], any: true)
      #temporal solution for the "for SELECT DISTINCT, ORDER BY expressions must appear in select list" issue
      #need to add uni_years and semesters collumn into select operation
      #because we need to use them to order later
      @subjects = @subjects.select('distinct subjects.*, uni_years.no, semesters.no')
      .joins(:semester).joins(:uni_year)
      .joins("LEFT JOIN taggings on subjects.id = taggings.taggable_id")
      .joins("LEFT JOIN tags on tags.id = taggings.tag_id").where('tags.name IN (?)', params[:tags])
    end   
    
    #order option
    @user = current_user
    if @user
      #update settings style for subject
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
      end
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
    # need current_user's infos for schedule_menu
    @user = current_user
    
    @tags = @subject.tag_list
    
    if !params[:tag].blank?
      #filter in show subject page
      @notes = @subject.notes.tagged_with(params[:tag])
    else
      @notes = @subject.notes
    end
    
    #order by view count
    @notes = @notes.order('view_count DESC')
    
    # custom show
    @show_subject = false
    @show_course = true
    
    # same subjects, need to change later
    @same_subjects = @subject.course.subjects.where(name: @subject.name).order('year DESC')
    
    # recommend subjects
    @recommend_subjects = @subject.course.subjects.where('semester_id = ? AND id != ?', @subject.semester, @subject.id).order('view_count DESC, notes_count DESC').limit(8)
    
    respond_to do |format|
      format.html 
      format.js   
    end
  end

  # GET /subjects/new
  def new
    @subject = Subject.new

    prepare_view_content
  end

  # GET /subjects/1/edit
  def edit
    prepare_view_content
    
    @tags = @subject.tag_list
  end

  # POST /subjects
  # POST /subjects.json
  def create
    #prepare previous info
    prepare_view_content
    
    #create new subject
    @subject = Subject.new(subject_params)
    @subject.teachers = Teacher.where(id: params[:teachers])
    
    #convert full-width to half-width
    tags_text = Moji.normalize_zen_han(params[:tags])
    tags = tags_text.split(',')
    @subject.tag_list = tags
    
    #create first outlines
    (1..params[:number_of_outlines].to_i).each do |i|
      outline = Outline.new(no: i)
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
  
  #outline for form
  def outline
    #add outlines
    new_number = params[:number_of_outlines].to_i
    old_number = @subject.outlines.count
    if old_number > new_number
      #delete old outlines
      @subject.outlines.where('no > ?', new_number).destroy_all
    else
      #add new outlines
      old_number = old_number + 1
      (old_number..new_number).each do |i|
        outline = Outline.new(no: i)
        @subject.outlines << outline
      end
    end   
  end
  
  #inline in syllabus
  def inline
    # for inline edit
    case params[:name].to_s
    when 'date'
      #search in array 
      outline = @subject.outlines.find_by_no(params[:pk])
      outline.date = DateTime.strptime(params[:value], '%Y-%m-%d') unless params[:value].blank?
      outline.save
    when 'content'
      #search in array 
      outline = @subject.outlines.find_by_no(params[:pk])
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
  
  # for /tags.json
  def tags
    @tags = @subject.tag_list
    respond_to do |format|
      format.json { render json: @tags }
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    #prepare previous info
    prepare_view_content
    
    @tags = @subject.tag_list
    
    #update tags list
    #convert full-width to half-width
    tags_text = Moji.normalize_zen_han(params[:tags])
    tags = tags_text.split(',')
    @subject.tag_list = tags
    
    #add teachers
    @subject.teachers = Teacher.where(id: params[:teachers])
    
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
      format.html { redirect_to subjects_path }
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
      params.permit(:name, :pk, :value, :tags, :filter, :semester, :teachers, :version_id, :page, :style, :number_of_outlines, :courses, :semesters)
      params.require(:subject).permit(:name, :description, :year, :place, :semester_id, :uni_year_id, :course_id, :picture, periods_attributes: [:id, :time, :day, :_destroy])
    end
end
