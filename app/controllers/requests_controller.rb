class RequestsController < ApplicationController
  def new
    @request = Request.new
  end

  def create
    #check if request university existed
    @request = Request.find_by_name(request_params[:name].strip)
    
    #add count or create new request
    if @request == nil
      @request = Request.new(request_params)
    else
      @request.count += 1
    end
    
    #render only json
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
