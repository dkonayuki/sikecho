class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
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
    @note = Note.new(note_params)
    #path = Rails.root.join('public','uploads', @user.nickname, params[:upload][:datafile].original_filename)
        
    #@note.pdf_path = "#{Rails.root}/public/uploads/#{@user.nickname}/#{params[:upload][:datafile].original_filename}"
    @note.user = @user
    if note_params[:subject].blank? 
      puts 'subject blank'
    end
    if !params[:subject].blank?
      puts 'params subject not blank'
    end
    @note.subjects << Subject.find( params[:subject] )
    #save_file( @user, params[:upload][:datafile].original_filename, params[:upload][:datafile] )
        
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
      params.require(:note).permit(:title, :content, :pdf_path, :user_id, :subject)
    end
end
