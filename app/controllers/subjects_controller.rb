class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  
  # GET /subjects
  # GET /subjects.json
  def index
    @user = current_user
    
    #filter tag
    if !params[:tag].blank?
      @subjects = @user.faculty.subjects.tagged_with(params[:tag])
    #filter semester
    elsif !params[:semester].blank?
      year = @user.university.uni_years.find_by_no(params[:year].to_i)
      semester = year.semesters.find_by_no(params[:semester].to_i)
      #filter from user's faculty subjects
      @subjects = @user.faculty.subjects.select { | subject | subject.semester == semester }
    #all
    else
      @subjects = @user.faculty.subjects.search(params[:search])
    end
    
    #other opstion: render action: "index"
  end
  
  #filter in show subject page
  def notes
    @subject = Subject.find(params[:id])
    @notes = @subject.notes.tagged_with(params[:tag])
    @show_subject = false
    render action: 'show'
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
    @notes = @subject.notes
    @show_subject = false
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit
  end

  # POST /subjects
  # POST /subjects.json
  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Subject was successfully created.' }
        format.json { render action: 'show', status: :created, location: @subject }
      else
        format.html { render action: 'new' }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    # for inline edit
    case params[:name].to_s
    when 'description'
      @subject.description = params[:value]
    when 'date'
      #search in array 
      outline = @subject.outlines.find_by_number(params[:pk])
      outline.date = DateTime.strptime(params[:value], '%Y年%m月%d日')
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
      params.permit(:name, :value, :tag, :semester, :year)
      params.require(:subject).permit(:name, :description)
    end
end
