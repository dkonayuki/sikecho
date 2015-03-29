class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy, :inline, :version, :outline, :tags, :periods, :new_auto, :reload]
  before_action :authenticate_user!, only: [:edit, :update, :new, :create]
  load_and_authorize_resource only: [:new, :edit, :destroy]
  
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
    # need to add select distinct to prevent duplicate items
    @subjects = @university.subjects.select('distinct subjects.*')
    
    #filter courses, use OR  
    if !params[:courses].blank?
      #get courses
      courses = Course.where(id: params[:courses])
      #filter
      @subjects = @subjects.where(course: courses)
    end
    
    #filter semesters, use OR
    if !params[:semesters].blank?
      #get semesters
      semesters = Semester.where(id: params[:semesters])
      #filter
      @subjects = @subjects.where(semester: semesters)    
    end
    
    #filter day
    if !params[:day].blank? && params[:day].to_i != 0
      @subjects = @subjects
      .joins(:periods).where('periods.day = ?', params[:day].to_i)
    end
    
    #filter time
    if !params[:time].blank? && params[:time].to_i != 0
      @subjects = @subjects
      .joins(:periods).where('periods.time = ?', params[:time].to_i)      
    end

    #filter tag, use OR
    if !params[:tags].blank?
      #@subjects = @subjects.tagged_with(params[:tags], any: true)
      #solution for the "for SELECT DISTINCT, ORDER BY expressions must appear in select list" issue
      #need to add uni_years and semesters collumn into select operation
      #because we need to use them to order later
      #note that semester and uni_year are singular because of the relationship
      @subjects = @subjects
      .joins(:semester).joins(:uni_year)
      .joins("LEFT JOIN taggings on subjects.id = taggings.taggable_id")
      .joins("LEFT JOIN tags on tags.id = taggings.tag_id").where('tags.name IN (?)', params[:tags])
    end
    
    #order option
    @user = current_user

    if @user
      #update settings style for subject
      if !params[:order].blank?
        @user.settings(:subject).order = params[:order].to_sym
        @user.save
      end
      
      #reorder subjects list
      # need to perform order to return relation class for further processing
      # array will not work
      case @user.settings(:subject).order
      when :all
        @subjects = @subjects.order('year DESC, name ASC, view_count DESC')
      when :semester
        @subjects = @subjects.joins(:semester).joins(:uni_year).order('uni_years.no ASC, semesters.no ASC')
      when :note_count
        @subjects = @subjects.order('notes_count DESC')
      end
    else
      #default option for guest user
      @subjects = @subjects.order('year DESC, name ASC, view_count DESC')
    end
    
    #search subjects list
    @subjects = @subjects.search(params[:search])
    
    #paginate @subjects
    # only work on collection proxy or relation
    # page method from kaminari
    # return relation (associationrelation)
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
    
    #default
    @notes = @subject.notes

    unless params[:operation].blank?
      @operation = params[:operation].to_sym
      case @operation
      when :version
        #display version
        #revert to previous version
        if !params[:version_id].blank?
          @subject = @subject.versions.find(params[:version_id]).reify
        end
      when :outline
        #filter note in show subject page
        if !params[:outline].blank?
          #if outline == 0 use the default @notes
          if params[:outline].to_i != 0
            @notes = @subject.notes.tagged_with(params[:outline])
          end
        end
      when :show_more
        #nothing
      when :register
        #nothing
      else
        #default
      end
    end
    
    #get subject tags
    @tags = @subject.tag_list
    
    #order by view count
    @notes = @notes.order('view_count DESC')
    
    #paginate @notes
    # only work on collection proxy or relation
    # page method from kaminari
    # return relation (associationrelation)
    @notes = @notes.page(params[:page]).per(4)
    
    # same subjects name but different year
    @same_subjects = @subject.course.subjects.where(name: @subject.name).order('year DESC')
    
    # recommend subjects
    # TODO need to improve the recommendations
    @recommend_subjects = @subject.course.subjects.where('semester_id = ? AND id != ?', @subject.semester, @subject.id).order('view_count DESC, notes_count DESC').limit(7)
    
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
  end
  
  # GET /subjects/reload/1
  def reload
    respond_to do |format|
      format.js
    end
  end

  # POST /subjects
  # POST /subjects.json
  def create
    #prepare previous info
    prepare_view_content
    
    #create new subject
    @subject = Subject.new(subject_params)
    @subject.teachers = current_university.teachers.where(id: params[:subject][:teachers])
    
    #add periods
    if !params[:periods].blank?
      params[:periods].each do |period_text|
        period = period_text.split(',')
        @subject.periods << Period.new(day: period[0], time: period[1])
      end
    end
    
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
        #create activity for new feeds
        @subject.create_activity :create, owner: current_user
        
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
  
  # POST /subjects/:id/new_auto/:auto_type
  def new_auto
    #add 1 outline
    if (params[:auto_type].to_i == 0)
      outline = @subject.outlines.last.dup
      if !outline.date.blank?
        outline.date += 1.week
      end
      outline.no += 1
      @subject.outlines << outline
    elsif (params[:auto_type].to_i == 1)
    #add all outlines

    end
    respond_to do |format|
      format.js   
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
    case params[:name].to_sym
    when :date
      #search in array 
      outline = @subject.outlines.find_by_no(params[:pk])
      outline.date = Date.strptime(params[:value], '%Y-%m-%d') unless params[:value].blank?
      outline.save
    when :content
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
  
  # for /subjects/tags.json
  def tags
    @tags = @subject.tag_list
    respond_to do |format|
      format.json { render json: @tags }
    end
  end
  
  # for GET /subjects/periods.json
  def periods
    @periods = @subject.periods
    respond_to do |format|
      format.json { render json: @periods }
    end
  end
  
  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    #prepare previous info
    prepare_view_content
    
    #update periods list
    periods = Array.new
    params[:periods].each do |period_text|
      period = period_text.split(',')
      periods << Period.new(day: period[0], time: period[1])
    end
    @subject.periods = periods
    
    #update tags list
    #convert full-width to half-width
    tags_text = Moji.normalize_zen_han(params[:tags])
    tags = tags_text.split(',')
    @subject.tag_list = tags
    
    #add teachers
    @subject.teachers = current_university.teachers.where(id: params[:subject][:teachers])
            
    #delete image
    #present? is equivalent to !blank?
    if params[:remove_picture].present? && params[:remove_picture].to_i == 1
      if @subject.picture.present? 
        @subject.picture.destroy
      end
    end
    
    respond_to do |format|
      if @subject.update(subject_params)
        #create activity for new feeds
        @subject.create_activity :update, owner: current_user
        
        #broadcast for all other related users
        @subject.registered_users.each do |user|
          broadcast_notification("/users/#{user.id}")
        end
        
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
    #delete the related activity
    @activity = PublicActivity::Activity.find_by_trackable_id(params[:id])
    
    @activity.destroy
    
    #broadcast for all other related users
    @subject.registered_users.each do |user|
      broadcast_notification("/users/#{user.id}")
    end
    
    @subject.destroy
    
    respond_to do |format|
      format.html { redirect_to subjects_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      # only show subject belongs to appropriate subdomain/university
      @subject = current_university.subjects.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      #subject show page: outline, page, operation, version_id
      #subject edit: remove_picture, periods, number_of_outlines, tags
      params.permit(:name, :pk, :value, :tags, :version_id, :page, :order, :search, :number_of_outlines, :courses, :semesters, :periods, :auto_type, :outline, :operation, :remove_picture)
      params.require(:subject).permit(:name, :description, :year, :place, :semester_id, :uni_year_id, :course_id, :picture, :teachers)
    end
end
