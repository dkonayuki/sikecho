class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_document #set document for all actions, shallow: false
  before_action :set_user #set user for all actions, for comment menu working
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index, :show, :new, :edit, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    # index action is not called
    # @comments collection will be retrieved in document controller 
    # or view using document.comments
    
    # kaminari pagination is also implemented in document show action
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    #need @comment = @document.comments.build at form or at document controller because ajax-popup call index instead of new action
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @document.comments.new(comment_params)
    @comment.user = @user

    respond_to do |format|
      if @comment.save
        format.html
        format.js
        format.json { render action: 'show', status: :created, location: @comment }
      else
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
        format.js # execute js file when fail to update or cancel btn clicked
      elsif @comment.update(comment_params)
        format.html
        format.js
        format.json { render action: 'show', status: :updated, location: @comment }
      else
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
    
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to document_comments_path(@comment.document) }
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
    def set_document
      @document = Document.find(params[:document_id])  
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      # need :is_update parameter to distinguish whenever user clicked on update or cancel button
      # :is_update is passed from additional button in form
      # f.submit won't allow custom block content and additional parameter
      params.permit(:document_id, :is_update)
      params.require(:comment).permit(:content)
    end
end
