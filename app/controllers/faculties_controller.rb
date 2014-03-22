class FacultiesController < ApplicationController
  before_action :set_faculty, only: [:show, :edit, :update, :destroy]
  before_action :set_university

  # GET /universities/:university_id/faculties
  # GET /universities/:university_id/faculties
  def index
    @faculties = @university.faculties
  end

  # GET /universities/:university_id/faculty/1
  # GET /universities/:university_id/faculty/1.json
  def show
  end

  # GET /universities/:university_id/faculties
  def new
    @faculty = @university.faculties.build
  end

  # GET /universities/:university_id/faculties/1/edit
  def edit
  end

  # POST /universities/:university_id/faculties
  # POST /universities/:university_id/faculties.json
  def create
    @faculty = @university.faculties.new(faculty_params)

    respond_to do |format|
      if @faculty.save
        format.html { redirect_to [@faculty.university, @faculty], notice: 'Faculty was successfully created.' }
        format.json { render action: 'show', status: :created, location: @faculty }
      else
        format.html { render action: 'new' }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /universities/:university_id/faculties/1
  # PATCH/PUT /universities/:university_id/faculties/1.json
  def update
    respond_to do |format|
      if @faculty.update(faculty_params)
        format.html { redirect_to [@faculty.university, @faculty], notice: 'Faculty was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /universities/:university_id/faculties/1
  # DELETE /universities/:university_id/faculties/1.json
  def destroy
    @faculty.destroy
    respond_to do |format|
      format.html { redirect_to university_faculties_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faculty
      @faculty = Faculty.find(params[:id])
    end
    
    def set_university
      @university = University.find(params[:university_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def faculty_params
      params.permit(:university_id)
      params.require(:faculty).permit(:name, :website)
    end
end
