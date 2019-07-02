class SessionsController < ApplicationController
  def new
  end
  def create
    
    muser = MUser.find_by(email: params[:session][:email].downcase)
    if muser && muser.authenticate(params[:session][:password])
      if muser.activated?
        log_in muser
        #log mworkspace
        redirect_to workspacecreate_path
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to login_path
      end
      # Log the user in and redirect to the user's show page.
    else
      flash.now[:danger]  = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end
  def newworkspace
    @mworkspace = MWorkspace.new   
    
  end

  def channelcreate
    @mworkspace = MWorkspace.new(workspace_params)
    @mworkspace.admin = 1
    @mworkspace.user_id = session[:muser_id]
    if @mworkspace.save
      session[:workspace_name] = @mworkspace.workspace_name
      mworkspace = MWorkspace.find_by(workspace_name: session[:workspace_name])
      log mworkspace
      redirect_to home_path
    else
      render 'new'
    end
  end


  def destroy
    log_out
    redirect_to root_url
  end
  private
  def workspace_params
    params.require(:mworkspace).permit(:workspace_name)
  end

end
