class RequestsController < ApplicationController
  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    if @request.save
      render json: {success: true}
    else 
      render json: {success: false}
    end
  end
  
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.require(:request).permit(:name, :address, :website)
  end
  
end
