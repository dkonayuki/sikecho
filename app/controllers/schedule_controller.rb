class ScheduleController < ApplicationController
  def index
    @user = User.find_by_id(session[:user_id])
    get_schedule_content
    @editable = true
        
    @user.subjects.each do |subject|
      puts subject.name
    end
  end

  # GET /schedule/new
  def new
    @user = current_user
    subjects = @user.faculty.subjects.all
    #great filter stuff, always remember pass params as to_i
    @subjects = subjects.select { | subject | subject.time == params[:time].to_i && subject.day == params[:day].to_i }
  end
  
  def edit
    @user = current_user
    subjects = @user.faculty.subjects.all
    
    #@subjects is for select_tag
    @subjects = subjects.select { | subject | subject.time == params[:time].to_i && subject.day == params[:day].to_i }
    #need @subject for default tag, old_subject ( to update )
    @subject = @subjects.detect{|s| s.id == params[:subject].to_i}
  end
  
  # PUT /schedule/new
  # params[:subject, :old_subject]
  def create
    @user = current_user 
    subjects = @user.faculty.subjects.all
    @subject = subjects.detect{|s| s.id == params[:subject].to_i}
    @user.subjects << @subject
    @user.save
    
    redirect_to schedule_path
  end

  def update
    @user = current_user 
    subjects = @user.faculty.subjects.all
    #delete old subject and create a new one
    subject = subjects.detect{|s| s.id == params[:old_subject].to_i}
    @user.subjects.delete(subject)
    subject = subjects.detect{|s| s.id == params[:subject].to_i}
    @user.subjects << subject
    
    redirect_to schedule_path
  end
  
  def destroy
    @user = current_user
    subjects = @user.faculty.subjects.all
    #delete subject user relationshp
    subject = subjects.detect{|s| s.id == params[:subject].to_i}
    @user.subjects.delete(subject)
    redirect_to schedule_path
  end
  
end
