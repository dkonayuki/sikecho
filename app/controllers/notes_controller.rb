class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @user = current_user
    @show_subject = true
    
    puts params.inspect
    if params[:filter].blank? 
      @notes = @user.notes.search(params[:search]).order('created_at DESC').to_a #use this method instead of .all
    else
      case params[:filter] 
      when '自分のノート'    #filter=1 : user's notes
        @notes = @user.notes.search(params[:search]).order('created_at DESC').to_a
      when '授業のノート'    #filter=2 : subject's notes
        @notes = Array.new
        @user.subjects.each do | subject |
          subject.notes.search(params[:search]).order('created_at DESC').each do | note |
            @notes << note
          end
        end
      when '新着ノート' #filter=3 : new notes
        @notes = Note.unread_by(@user).search(params[:search]).order('created_at DESC').to_a
      else
        #default
        @notes = @user.notes.search(params[:search]).order('created_at DESC').to_a #use this method instead of .all
      end
      
      #respond with js format, index.js.erb will be run
      respond_to do |format|
        format.html { redirect_to :notes }
        format.js   {}
        format.json { render json: @notes, status: :ok, location: :notes }
      end
    end
    
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @user = current_user
    @note.mark_as_read! for: @user
    @tags = @note.tag_list
  end

  # GET /notes/new
  def new
    @note = Note.new
    @user = current_user
    @subjects = @user.faculty.subjects
  end

  # POST /notes
  # POST /notes.json
  def create
    #convert full-width to half-width
    tags_text = Moji.zen_to_han(params[:tags])
    puts tags_text.inspect
    tags = tags_text.split(',')
    @user = current_user
    @note = Note.new(note_params)
    @note.tag_list = tags

    @subjects = @user.faculty.subjects
    #search object in array , or can do @subject.find_by_id(id)
    subject = @subjects.detect{|s| s.id == params[:subject].to_i}

    #add relationship
    @note.subjects << subject
    @note.user = @user


    #save document
    puts params.inspect
    if !params[:document].blank?
      path = save_file( @user, params[:document].original_filename, params[:document] )
      @document = Document.new(path: path, name: params[:document].original_filename)
      @document.save
      @note.documents << @document
    end
    
    respond_to do |format|
      if @note.save
        # need to save b4 mark as read
        @note.mark_as_read! for: @user
        format.html { redirect_to notes_url, notice: 'Note was successfully created.' }
        format.json { render action: 'show', status: :created, location: @note }
      else
        format.html { render action: 'new' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def delete_document
    #need to deploy
    @document = Document.find( params[:id] )
    #delete_file(@document.path)
    #@document.destroy
    redirect_to notes_path
  end
  
  def download
    # Download a document file 
    @document = Document.find( params[:id] )
    send_file(@document.path.strip,:type=>"application/pdf")
  end
  
  # GET /notes/1/edit
  def edit
    @subjects = @user.faculty.subjects
    @note = Note.find( params[:id] )    
    @subject = @note.subjects.first
    @tags = @note.tag_list
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    # Update subject and document
    #@note = Note.find( params[:id] )
    
    # update tags list
    tags = params[:tags].split(',')
    @note.tag_list = tags
    
    # delete old_subject and add a new one
    subjects = @user.faculty.subjects
    subject = subjects.detect{|s| s.id == params[:old_subject].to_i}
    @note.subjects.delete(subject)
    subject = subjects.detect{|s| s.id == params[:subject].to_i}
    @note.subjects << subject
    
    # update document
    if !params[:document].blank?
      path = save_file( @user, params[:document].original_filename, params[:document] )
      @document = Document.new(path: path, name: params[:document].original_filename)
      puts params[:document].original_filename
      @document.save
      @note.documents << @document
    end
    
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
      format.html { redirect_to :notes }
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
      params.permit(:document, :tags, :subject, :old_subject)
      params.require(:note).permit(:title, :content)
    end

end