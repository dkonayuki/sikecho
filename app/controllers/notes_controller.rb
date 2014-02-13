class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @user = current_user
    @notes = @user.notes.order('created_at DESC').to_a #use this method instead of .all
    @show_subject = true
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @user = current_user
    @note.mark_as_read! for: @user
    @tags = @note.tag_list
  end
  
  def filter
    @user = current_user
    @show_subject = true
    
    case params[:type].to_i 
    when 1    #filter/id=1 : user's notes
      @notes = @user.notes.order('created_at DESC').to_a
      #user can edit notes
      @editable = true
    when 2    #filter/id=2 : subject's notes
      @notes = Array.new
      @user.subjects.each do | subject |
        subject.notes.order('created_at DESC').each do | note |
          @notes << note
        end
      end
      #sort desc
      #@notes.sort_by {| note | note.created_at}.reverse
      #@notes.sort_by(&:created_at).reverse
      #user can not edit notes
      @editable = false
    when 3
      @notes = Note.unread_by(@user).order('created_at DESC').to_a
      #user can not edit notes
      @editable = false
    else
      #no implement
    end
    render action: "index"
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
    puts params.inspect
    tags_text = Moji.zen_to_han(params[:tags])
    tags = tags_text.split(',')
    @user = current_user
    @note = Note.new(note_params.except(:document))
    @note.tag_list = tags

    @subjects = @user.faculty.subjects
    #search object in array
    subject = @subjects.detect{|s| s.id == params[:subject].to_i}

    #add relationship
    @note.subjects << subject
    @note.user = @user


    #save document
    if !note_params[:document].blank?
      path = save_file( @user, note_params[:document].original_filename, note_params[:document] )
      @document = Document.new(path: path, name: note_params[:document].original_filename)
      puts note_params[:document].original_filename
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
    @note = Note.find( params[:id] )
    
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
    if !note_params[:document].blank?
      path = save_file( @user, note_params[:document].original_filename, note_params[:document] )
      @document = Document.new(path: path, name: note_params[:document].original_filename)
      puts note_params[:document].original_filename
      @document.save
      @note.documents << @document
    end
    
    respond_to do |format|
      if @note.update(note_params.except(:document))
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
      format.html { redirect_to :back }
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
      params.require(:note).permit(:title, :content, :user_id, :document)
    end

end