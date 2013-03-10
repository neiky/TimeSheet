class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    #puts "fine"
    #if current_user
    #@employment = Employment.where(:employee_id => current_user.id).first
    #if !@employment
      #@self_employment = Employment.where("employer_id = ? OR employee_id = ?", current_user.id, current_user.id).first
      #if !@self_employment
        #@self_employment = Employment.new(:employer_id => current_user.id, :employee_id => 0, :workingtime_per_day => 28800, :employment_date => Date.today, :accepted => true)
        #if !@self_employment.save
          #flash[:alert] = "Failed creating employment settings for you!"
        #else
          #current_user.update_attributes(:employment_id => @self_employment.id)
        #end
       #end
    #end
  end
end
