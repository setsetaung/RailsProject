class AccountActivationsController < ApplicationController

    def edit
        muser = MUser.find_by(email: params[:email])
        if muser && !muser.activated? && muser.authenticated?(:activation, params[:id])
          muser.update_attribute(:activated,    true)
          muser.update_attribute(:activated_at, Time.zone.now)
          muser.activate
          log_in muser
          flash[:success] = "Account activated!"
          redirect_to workspacecreate_path
        else
          flash[:danger] = "Invalid activation link"
          redirect_to signup_path
        end
      end
end
