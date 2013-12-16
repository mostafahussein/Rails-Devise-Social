class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => [:check_email]

  def check_email
    @user = User.find_by_email(params[:user][:email])
    respond_to do |format|
      format.json { render :json => !@user }
    end
  end

  def profil
    set_tab :profile
    @user = current_user
    @company = Company.find_by_user_id(@user["id"])
    
    if request.put?
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Profil wurde erfolgreich aktualisiert.'
      else
        flash[:error] = @user.errors.values[0][0]
      end
    end
  end
  def company
    set_tab :profile
    @user = current_userrt.
      else
        flash[:error] = @user.errors.values[0][0]
      end
    end
  end
  def company
    set_tab :profile
    @user = current_user
    @company = Company.find_by_user_id(@user["id"])
    @region = Region.all
    @city = City.all
    
    
    if request.put?
       
      if @company.update_attributes(params[:company])
        flash[:notice] = 'Company information has be stored successfully'
      else
        flash[:error] = @company.errors.values[0][0]
      end
    end
  end 
  def billing
    set_tab :billing
    @user = current_user
    @user_billing = UsersBilling.find_by_user_id(@user["id"])
    
  end
end
