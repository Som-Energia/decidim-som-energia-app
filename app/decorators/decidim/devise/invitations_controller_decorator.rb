# frozen_string_literal: true

Decidim::Devise::InvitationsController.class_eval do
  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    set_minimum_password_length
    resource.invitation_token = params[:invitation_token]

    if cas_user?
      redirect_to cas_user_path
    else
      render :edit
    end
  end

  private

  def cas_user?
    Decidim::ParticipatorySpacePrivateUser.find_by(user: resource)&.cas_user?
  end

  def cas_user_path
    # The following view:
    #   decidim-cas-client/app/views/decidim/shared/_login_modal.html.erb
    # Calls the following url_helper:
    #   new_user_cas_session_path
    # But I dunno how to call it. Tried the following without luck:
    #   Rails.application.routes.url_helpers.new_user_cas_session_path

    "/users/cas/sign_in"
  end
end
