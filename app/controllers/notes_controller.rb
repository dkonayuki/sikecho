class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @user = current_user
    @notes = @user.notes.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
    @user = current_user
    @subjects = Subject.all
  end

  # GET /notes/1/edit
  def edit
    @subjects = Subject.all
  end

  # POST /notes
  # POST /notes.json
  def create
    @user = current_user
    @note = Note.new(note_params.except(:document, :subject))
        
    @note.subjects << Subject.find( params[:subject] )
    @note.user = @user
    if !note_params[:document].blank?
      path = save_file( @user, note_params[:document].original_filename, note_params[:document] )
      @document = Document.new(path: path, name: note_params[:document].original_filename)
      puts note_params[:document].original_filename
      @document.save
      @note.documents << @document
    end
    
    respond_to do |format|
      if @note.save
        format.html { redirect_to notes_url, notice: 'Note was successfully created.' }
        format.json { render action: 'show', status: :created, location: @note }
      else
        format.html { render action: 'new' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def download
    # Download a document file 
    @document = Document.find( params[:id] )
    send_file(@document.path.strip,:type=>"application/pdf")
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to notes_url, notice: 'Note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :content, :pdf_path, :user_id, :document)
    end
end