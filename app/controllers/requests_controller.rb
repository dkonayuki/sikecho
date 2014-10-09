class RequestsController < ApplicationController
  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    
    respond_to do |format|
      if @request.save
        format.html
        format.json { render status: :created }
      else
        format.html
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.require(:param).permit(:name, :address, :website)
  end
  
end
