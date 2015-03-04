class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # activities index can be viewed in home page    
  end
end
