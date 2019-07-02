class MuserController < ApplicationController
  def show

  end

  def new
    @muser = MUser.new
  end

  def create
    @muser = MUser.new(user_params)    # Not the final implementation!
    if @muser.save
      session[:muser_name] = @muser.user_name
      @muser.send_activation_email
      MUserMailer.account_activation(@muser).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to signup_path
    else
      render 'new'
    end
  end

  def search
    mworkspace = MWorkspace.find_by(workspace_name: params[:workspace][:workspace_name])
    museremail=MUser.find_by(email: params[:workspace][:email].downcase)
    
    if mworkspace && museremail && museremail.authenticate(params[:workspace][:password])
      
      log mworkspace
      mworkspace = MWorkspace.find_by(workspace_name: session[:workspace_name])
      log mworkspace
      flash[:info] = "Found your Workspace"
      redirect_to home_path
      # Log the user in and redirect to the user's show page.
    else
      flash[:danger]  = 'Invalid email/password/workspace name combination' # Not quite right!
      redirect_to searchworkspace_path
    end
  end
  
  
  private
    def user_params
      params.require(:muser).permit(:user_name, :email, :password,
                                   :password_confirmation)
    end
end
