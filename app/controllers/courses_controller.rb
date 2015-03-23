class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :set_faculty, only: [:index, :new, :create]
  load_and_authorize_resource only: [:index, :show, :new, :edit, :destroy]

  # GET /faculties/faculty_id/courses
  # GET /faculties/faculty_id//courses.json
  def index
    #not in use
    #@courses = @faculty.courses
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    #not in use
  end

  # GET /faculties/faculty_id/courses/new
  def new
    #not in use
    #@course = @faculty.courses.build
  end

  # GET /courses/1/edit
  def edit
    #not in use
  end

  # POST /courses
  # POST /courses.json
  def create
    #not in use
    @course = @faculty.courses.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to faculty_courses_path(@faculty), notice: 'Course was successfully created.' }
        format.json { render action: 'show', status: :created, location: @course }
      else
        format.html { render action: 'new' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    #not in use
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    #not in use
    @course.destroy
    respond_to do |format|
      format.html { redirect_to faculty_courses_path(@course.faculty) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
    
    def set_faculty
      @faculty = Faculty.find(params[:faculty_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.permit(:faculty_id)
      params.require(:course).permit(:name)
    end
end
