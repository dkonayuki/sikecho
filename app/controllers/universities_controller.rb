class UniversitiesController < ApplicationController
  before_action :set_university, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:index, :show, :new, :edit, :destroy]

  # GET /universities
  # GET /universities.json
  def index
    @universities = University.search(params[:search])
    
    if !params[:area].blank?
      # select only university which has city in correct area
      @universities = @universities.where('universities.city IN (?)', University.areas[params[:area].to_i])
    end
    
    #respond with js format, index.js.erb will be run
    respond_to do |format|
      format.html {}
      format.js   {}
      format.json { render json: @universities, status: :ok }
    end
  end

  # GET /universities/1
  # GET /universities/1.json
  def show
  end

  # GET /universities/new
  def new
    #not in use
    #@university = University.new
  end

  # GET /universities/1/edit
  def edit
    #not in use
  end

  # POST /universities
  # POST /universities.json
  def create
    #not in use
    @university = University.new(university_params)

    respond_to do |format|
      if @university.save
        format.html { redirect_to @university, notice: 'University was successfully created.' }
        format.json { render action: 'show', status: :created, location: @university }
      else
        format.html { render action: 'new' }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /universities/1
  # PATCH/PUT /universities/1.json
  def update
    #not in use
    respond_to do |format|
      if @university.update(university_params)
        format.html { redirect_to @university, notice: 'University was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /universities/1
  # DELETE /universities/1.json
  def destroy
    #not in use
    @university.destroy
    
    respond_to do |format|
      format.html { redirect_to universities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_university
      @university = University.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def university_params
      params.permit(:search, :area)
      params.require(:university).permit(:name, :address, :website, :logo)
    end
end
