class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :redirect_if_authenticated, only: [ :new ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_registration_url, inertia: { errors: { base: [ "Too many attempts. Please try again later." ] } } }

  def new
    render inertia: "Auth/Signup"
  end
  def create
    begin
      user = User.new(user_params)
      user.save!
      start_new_session_for user
      assign_pending_event_creator(user)
      check_if_user_created_in_event_path
      if @pending_event
        flash[:notice] = t(".pending_event_success")
        redirect_to event_path(@pending_event)
      elsif @current_event
        flash[:notice] = t(".success")
        redirect_to event_path(@current_event)
      else
        flash[:notice] = t(".success")
        redirect_to root_path
      end
    rescue => e
      handle_error(e, new_registration_path)
    end
  end

  private
  def user_params
    params.permit(:name, :email_address, :password)
  end
end
