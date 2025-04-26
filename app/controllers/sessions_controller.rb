class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, inertia: { errors: { base: [ "Too many attempts. Please try again later." ] } } }

  def new
    render inertia: "Auth/Login"
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      flash[:notice] = t(".success")
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, inertia: { errors: { message: "Invalid email or password" } }
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
