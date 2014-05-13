class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy, :documents]
  impressionist actions: [:show]

  # GET /notes
  # GET /notes.json
  def index
    @user = current_user
    
    #custom show
    @show_notice = true
    @show_subject = true
    
    #enable endless page only params has :page
    if !params[:page].blank?
      @show_more = true
    end
    
    #process filter if has any
    if params[:filter].blank?
      #no filter, default: all
      @notes = @user.current_university.notes
    else
      case params[:filter] 
      when '自分のノート'
        @notes = @user.notes
      when '授業のノート'
        #select distinct notes from crazy joins
        @notes = Note.select('distinct notes.*').joins('INNER JOIN notes_subjects ON notes.id = notes_subjects.note_id')
        .joins('INNER JOIN subjects ON subjects.id = notes_subjects.subject_id')
        .joins('INNER JOIN periods ON periods.subject_id = subjects.id')
        .joins('INNER JOIN educations_periods ON educations_periods.period_id = periods.id')
        .joins('INNER JOIN educations ON educations.id = educations_periods.education_id')
        .where('educations.id = ?', @user.id)

      when '新着ノート'
        @notes = @user.current_university.notes.unread_by(@user)
      when 'すべて'
        @notes = @user.current_university.notes
      else
        #default
        @notes = @user.current_university.notes
      end
    end
    
    if !params[:order].blank?
      @user.settings(:note).order = params[:order].to_sym
      @user.save
    end
    #reorder
    case @user.settings(:note).order
    when :alphabet
      @notes = @notes.order('title ASC')
    when :time
      @notes = @notes.order('created_at DESC')
    when :view
      @notes = @notes.order('view_count DESC')
    end
    
    #search
    @notes = @notes.search(params[:search])
    #paginate @notes
    @notes = @notes.page(params[:page]).per(12)
    
    #respond with js format, index.js.erb will be run
    respond_to do |format|
      format.html 
      format.js
      format.json { render json: @notes, status: :ok, location: :notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @user = current_user
    @note.mark_as_read! for: @user
    @tags = @note.tag_list
  end
  
  # GET /notes/:id/documents
  # return documents.json for jquery upload file
  def documents
    respond_to do |format|
      format.html
      format.json { render json: @note.documents.map{|d| d.to_jq_upload } }
    end
  end

  # GET /notes/new
  def new
    @user = current_user
    @note = Note.new
    #create note from subject page, subject_id
    if !params[:subject_id].blank? 
      @note.subjects << Subject.find(params[:subject_id])
    end
    @subjects = @user.current_university.subjects
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
    @subjects = @user.current_university.subjects
    
    #add subjects
    @note.subjects = Subject.where(id: params[:note][:subjects])

    #add relationship
    @note.user = @user

    #create association between note and uploaded documents
    @note.documents = Document.where(id: params[:document_ids])
    
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
  
  # GET /notes/1/edit
  def edit
    @user = current_user
    @subjects = @user.current_university.subjects
    @note = Note.find(params[:id])
    @tags = @note.tag_list
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update    
    @user = current_user
    
    # update tags list
    tags = params[:tags].split(',')
    @note.tag_list = tags
    @tags = @note.tag_list
    
    #prepare subjects list
    @subjects = @user.current_university.subjects

    #update subjects
    @note.subjects = Subject.where(id: params[:note][:subjects])
    
    #update document
    @note.documents = Document.where(id: params[:document_ids])
   
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
      params.permit(:document, :tags, :filter, :subject_id, :document_ids, :page, :order)
      params.require(:note).permit(:title, :content, :subjects)
    end

end