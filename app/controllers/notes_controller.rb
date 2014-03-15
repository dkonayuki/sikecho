class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @user = current_user
    @show_subject = true
    
    #process filter if has any
    if params[:filter].blank? 
      @notes = @user.notes.search(params[:search]).order('created_at DESC')
      @search = params[:search]
    else
      case params[:filter] 
      when '自分のノート'    #filter=1 : user's notes
        @notes = @user.notes.search(params[:search]).order('created_at DESC')
      when '授業のノート'    #filter=2 : subject's notes
        @notes = Array.new
        @user.subjects.each do | subject |
          subject.notes.search(params[:search]).order('created_at DESC').each do | note |
            @notes << note
          end
        end
      when '新着ノート' #filter=3 : new notes
        @notes = Note.unread_by(@user).search(params[:search]).order('created_at DESC')
      else
        #default
        @notes = @user.notes.search(params[:search]).order('created_at DESC') 
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
    
    #increase view
    @note.view += 1
    @note.save
    
    #show documents
  end

  # GET /notes/new
  def new
    @user = current_user
    @note = Note.new
    #create note from subject page, subject_id
    if !params[:subject_id].blank? 
      @note.subjects << @user.faculty.subjects.find_by_id(params[:subject_id])
    end
    @subjects = @user.faculty.subjects
  end

  # POST /notes
  # POST /notes.json
  def create
    #convert full-width to half-width
    tags_text = Moji.zen_to_han(params[:tags])
    tags = tags_text.split(',')
    @user = current_user
    @note = Note.new(note_params)
    @note.tag_list = tags

    #prepare subjects list
    @subjects = @user.faculty.subjects
    
    #add subjects
    @note.subjects = @user.faculty.subjects.where(id: params[:subjects])

    #add relationship
    @note.user = @user
    
    #initiate view
    @note.view = 0

    #save document
    #if !params[:document].blank?
      #path = save_file( @user, params[:document].original_filename, params[:document] )
      #@document = Document.new(path: path, name: params[:document].original_filename)
      #@document.save
      #@note.documents << @document
    #end
    
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
  
  # for /tags.json
  def tags
    @tags = ActsAsTaggableOn::Tag.all
    respond_to do |format|
      format.html {}
      format.json { render json: @tags }
    end
  end
  
  # GET /notes/1/edit
  def edit
    @user = current_user
    @subjects = @user.faculty.subjects
    @note = Note.find( params[:id] )    
    @tags = @note.tag_list
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update        
    # update tags list
    tags = params[:tags].split(',')
    @note.tag_list = tags
    
    #prepare subjects list
    @subjects = @user.faculty.subjects

    # delete old_subject and add a new one
    @note.subjects = @user.faculty.subjects.where(id: params[:subjects])
    
    # update document
    #if !params[:document].blank?
      #path = save_file( @user, params[:document].original_filename, params[:document] )
      #@document = Document.new(path: path, name: params[:document].original_filename)
      #puts params[:document].original_filename
      #@document.save
      #@note.documents << @document
    #end
    
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
      params.permit(:document, :tags, :subjects, :filter, :subject_id)
      params.require(:note).permit(:title, :content)
    end

end