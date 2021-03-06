class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy, :documents, :tags, :like, :dislike, :star]
  impressionist actions: [:show] #for count number
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index, :show, :new, :edit, :destroy] #for ability
    
  include NotesHelper # need this to use helper method in view

  # GET /notes
  # GET /notes.json
  def index
    @user = current_user
    
    #custom show
    @show_notice = true
    
    #enable endless page only params has :page
    if !params[:page].blank?
      @show_more = true
    end
    
    #process filter if has any
    if params[:filter].blank?
      #no filter, default: registered_note
      @notes = @user.registered_notes
    else
      case params[:filter].to_sym
      when :my_note
        # need to add sql: SELECT DISTINCT notes.*
        # for later use in order by rating
        @notes = @user.notes.select('distinct notes.*')
      when :registered_note
        @notes = @user.registered_notes
      when :new_arrival_note
        @notes = @user.registered_notes.unread_by(@user)
      when :favorite
        @notes = @user.favorited_notes
      when :all
        @notes = @user.current_university.notes
      else
        #default
        @notes = @user.registered_notes
      end
    end
    
    #set order
    if !params[:order].blank?
      @user.settings(:note).order = params[:order].to_sym
      @user.save
    end
    
    #set layout
    if !params[:layout].blank?
      @user.settings(:note).layout = params[:layout].to_sym
      @user.save
    end

    #reorder
    case @user.settings(:note).order
    when :alphabet
      @notes = @notes.order('title ASC, view_count DESC')
    when :new
      @notes = @notes.order('created_at DESC')
    when :old
      @notes = @notes.order('created_at ASC')
    when :view
      @notes = @notes.order('view_count DESC')
    when :rating
      #need group by notes.id to use the aggregated function SUM
      #SUM(votes.value) will be caculated for each note
      @notes = @notes.select('SUM(votes.value) AS rating').joins(:votes).group('notes.id').order('rating DESC, view_count DESC')
    when :comment
      # .joins(documents: :comments) will use INNER JOIN, mean that note without documents or comments will not be displayed
      # by using LEFT JOIN, notes will be returned even documents or comments are null, which is desired for our system
      @notes = @notes.select('COUNT(comments.id) AS comment_count')
        .joins('LEFT JOIN documents ON documents.note_id = notes.id')
        .joins("LEFT JOIN comments ON comments.commentable_id = documents.id AND comments.commentable_type = 'Document'")
        .group('notes.id')
        .order('comment_count DESC, view_count DESC')
    else
      @notes = @notes.order('title ASC, view_count DESC')
    end
    
    #search
    @notes = @notes.search(params[:search])
    
    #paginate @notes
    # only work on collection proxy or relation
    # page method from kaminari
    # return relation (associationrelation)
    # kaminari can also paginate on array: Kaminari.paginate_array(my_array_object).page(params[:page]).per(10)
    # however it's better to unify to relation only
    @notes = @notes.page(params[:page]).per(20)
    
    # set layout
    case @user.settings(:note).layout
    when :all
      @layout = :all
    when :lecture
      # create hash of arrays from array by using group_by
      @notes_by_subject = @notes.group_by { |note| note.subjects.ordered.first }
      @layout = :lecture
    else
      #default
      @layout = :all
    end
    
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
    
    #mark as read for impression gem
    @note.mark_as_read! for: @user
    
    #get information for note like/dislike menu
    @vote = get_vote
    
    #get favorite information
    favorite = @note.favorites.find_by_user_id(current_user.id)
    if favorite
      @is_starred = 1
    else
      @is_starred = 0
    end
    
    #get previous note, next note
    notes = @note.subjects.first.notes
    @prev = notes.where('created_at < ?', @note.created_at).last
    @next = notes.where('created_at > ?', @note.created_at).first
    
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
  
  # POST /notes/1/like
  def like
    @vote = get_vote
    
    if @vote.value == 1
      @vote.value = 0
    else
      @vote.value = 1
    end
    @vote.save
    
    respond_to do |format|
      format.js
    end
  end
  
  # POST /notes/1/dislike
  def dislike
    @vote = get_vote
    
    if @vote.value == -1
      @vote.value = 0
    else
      @vote.value = -1
    end
    @vote.save
    
    respond_to do |format|
      format.js
    end
  end
  
  # POST /notes/1/star
  def star
    @user = current_user
    @is_starred = 1
    
    favorite = @note.favorites.find_by_user_id(current_user.id)
    if favorite
      if params[:star].to_i == 0
        favorite.destroy
        @is_starred = 0
      end
    else
      if params[:star].to_i == 1
        favorite = @note.favorites.create(user: @user)
        @is_starred = 1
      end
    end
  end

  # GET /notes/new
  def new
    @note = Note.new

    #create note from subject page, subject_id
    if !params[:subject_id].blank? 
      @note.subjects << current_university.subjects.find(params[:subject_id])
    end
    
    prepare_view_content
  end

  # POST /notes
  # POST /notes.json
  def create
    #convert full-width to half-width
    tags_text = Moji.zen_to_han(params[:tags])
    tags = tags_text.split(',')
    
    @note = current_user.notes.new(note_params)
    @note.tag_list = tags

    #prepare subjects list
    prepare_view_content
    
    #add subjects
    @note.subjects = current_university.subjects.where(id: params[:note][:subjects])

    #create association between note and uploaded documents
    @note.documents = Document.where(id: params[:document_ids])
    
    respond_to do |format|
      if @note.save
        # need to save b4 mark as read
        @note.mark_as_read! for: current_user
        
        #create activity for new feeds
        @note.create_activity :create, owner: current_user
        
        #broadcast for all other related users
        @note.registered_users.each do |user|
          broadcast_notification("/users/#{user.id}")
        end
        
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render action: 'show', status: :created, location: @note }
      else
        format.html { render action: 'new' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /notes/1/edit
  def edit
    prepare_view_content
    
    @note = Note.find(params[:id])
    @tags = @note.tag_list
  end
  
  # GET /notes/1/tags.json
  def tags
    @tags = @note.tag_list
    respond_to do |format|
      format.json { render json: @tags }
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    # update tags list
    tags = params[:tags].split(',')
    @note.tag_list = tags
    @tags = @note.tag_list
    
    #prepare subjects list
    prepare_view_content

    #update subjects
    @note.subjects = current_university.subjects.where(id: params[:note][:subjects])
    
    #update document
    @note.documents = Document.where(id: params[:document_ids])
   
    respond_to do |format|
      if @note.update(note_params)
                
        #create activity for new feeds
        @note.create_activity :update, owner: current_user
        
        #broadcast for all other related users
        @note.registered_users.each do |user|
          broadcast_notification("/users/#{user.id}")
        end
        
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
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
    #delete the related activity
    @activity = PublicActivity::Activity.find_by_trackable_id(params[:id])
    @activity.destroy
    
    #broadcast for all other related users
    @note.registered_users.each do |user|
      broadcast_notification("/users/#{user.id}")
    end
    
    @note.destroy
            
    respond_to do |format|
      format.html { redirect_to :notes }
      format.json { head :no_content }
    end
  end

  private
    # create vote if not existed
    def get_vote
      vote = @note.votes.find_by_user_id(current_user.id)
      unless vote
        # have no idea why this doesn't work: vote = Vote.create(user: current_user, value: 0)
        vote = Vote.create(user_id: current_user.id, value: 0)
        @note.votes << vote
      end
      vote
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      # only show note belongs to appropriate subdomain/university
      @note = current_university.notes.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.permit(:document, :tags, :filter, :subject_id, :document_ids, :page, :order, :layout, :search, :star)
      params.require(:note).permit(:title, :content, :subjects)
    end

end