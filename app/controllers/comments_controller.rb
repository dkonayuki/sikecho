class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_commentable #set commentable for all actions, shallow: false
  before_action :set_user #set user for all actions, for comment menu working
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index, :show, :new, :edit, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    # index action is not called
    # @comments collection will be retrieved in commentable controller (for instance: document)
    # or view using @commentable.comments
    
    # kaminari pagination is also implemented in commentable show action
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    #need @comment = @commentable.comments.build at form or at commentable controller because ajax-popup call index instead of new action
  end

  # GET /comments/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = @user

    respond_to do |format|
      if @comment.save
        # use @success instead of passing json success
        @success = true
        
        #create activity for new feeds
        @comment.create_activity :create, owner: current_user
        
        #broadcast for all other related users
        @comment.registered_users.each do |user|
          broadcast_notification("/users/#{user.id}")
        end
        
        format.html
        format.js
        format.json { render action: 'show', status: :created, location: @comment }
      else
        @success = false
        format.html
        format.js
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if !params[:is_update].nil? && params[:is_update] == 'false' # parameter is_update is string type
        @success = true
        format.js # execute js file when fail to update or cancel btn clicked
      elsif @comment.update(comment_params)
        # use @success instead of passing json success
        @success = true
        format.html
        format.js
        format.json { render action: 'show', status: :updated, location: @comment }
      else
        @success = false
        format.html
        format.js # execute js even when user delete content
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    # need to pass @id to view so js can replace the correct comment in view
    @id = params[:id]
    
    #delete the related activity
    @activity = PublicActivity::Activity.find_by_trackable_id(params[:id])
    @activity.destroy
    
    #broadcast for all other related users
    @comment.registered_users.each do |user|
      broadcast_notification("/users/#{user.id}")
    end
    
    @comment.destroy
    respond_to do |format|
      format.html {}
      format.js
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end
    
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # set @document for actions and views/js.erb file
    def set_commentable
      # user can only comment on Document at the momment
      # comment on subject and note can be implemented later, remember to add routes and params.permit
      # klass will detect the class passed in params, for instance, klass = Document
      klass = [Subject, Note, Document].detect { |c| params["#{c.name.underscore}_id"] }
      # find commentable in klass model
      @commentable = klass.find(params["#{klass.name.underscore}_id"])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      # need :is_update parameter to distinguish whenever user clicked on update or cancel button
      # :is_update is passed from additional button in form
      # f.submit won't allow custom block content and additional parameter
      params.permit(:document_id, :is_update, :id)
      params.require(:comment).permit(:content)
    end
end
