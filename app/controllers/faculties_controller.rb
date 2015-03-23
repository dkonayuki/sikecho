class FacultiesController < ApplicationController
  before_action :set_faculty, only: [:show, :edit, :update, :destroy]
  before_action :set_university, only: [:index, :new, :create]
  load_and_authorize_resource only: [:index, :show, :new, :edit, :destroy]

  # GET /faculties
  # GET /faculties
  def index
    #@faculties = @university.faculties
    #not in use
  end

  # GET /faculty/1
  # GET /faculty/1.json
  def show
    #not in use
  end

  # GET /faculties
  def new
    #@faculty = @university.faculties.build
    #not in use
  end

  # GET /faculties/1/edit
  def edit
    #not in use
  end

  # POST /faculties
  # POST /faculties.json
  def create
    #not in use
    @faculty = @university.faculties.new(faculty_params)

    respond_to do |format|
      if @faculty.save
        format.html { redirect_to university_faculties_path(@university), notice: 'Faculty was successfully created.' }
        format.json { render action: 'show', status: :created, location: @faculty }
      else
        format.html { render action: 'new' }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /faculties/1
  # PATCH/PUT /faculties/1.json
  def update
    #not in use
    respond_to do |format|
      if @faculty.update(faculty_params)
        format.html { redirect_to @faculty, notice: 'Faculty was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /faculties/1
  # DELETE /faculties/1.json
  def destroy
    #not in use
    @faculty.destroy
    respond_to do |format|
      format.html { redirect_to university_faculties_path(@faculty.university) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faculty
      @faculty = Faculty.find(params[:id])
    end
    
    def set_university
      #@university = University.find(params[:university_id])
      @university = current_university
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def faculty_params
      #params.permit(:university_id)
      params.require(:faculty).permit(:name, :website)
    end
end
