class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index, :show, :new, :edit, :destroy]

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    #prepare current user info for creating a new comment
    @user = current_user
    
    #prepare for new comment form
    @comment = @document.comments.build
    
    #comment collection
    @comments = @document.comments.order('created_at DESC')
    
    @comments = @comments.page(params[:page]).per(6)
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end
  
  # PUT /documents/inline
  def inline
    @document = Document.find(params[:pk])
    @document.title = params[:value]
    
    respond_to do |format|
      if @document.save
        format.html { redirect_to @document }
        format.json { render json: @document, status: :ok } # 204 No Content
      else
        format.html { render action: 'edit' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /documents
  # POST /documents.json
  # PATH /documents
  def create
    @document = Document.new(upload: params[:upload])
    @document.title = params[:title]
            
    respond_to do |format|
      if @document.save
        format.html {
          render json: [@document.to_jq_upload].to_json,
          content_type: 'text/html',
          layout: false
        }
        format.json { render json: {files: [@document.to_jq_upload]}, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    #delete uploaded file in amazon
    #bucket = AWS::S3.new.buckets['shikechou']
    #bucket.objects.delete(@document.upload.path)
    
    #destroy document
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.permit(:upload, :title, :pk, :value, :page)
      params.require(:document).permit(:note_id)
    end
end
