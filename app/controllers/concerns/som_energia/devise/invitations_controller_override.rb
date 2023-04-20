# frozen_string_literal: true

module SomEnergia
  module Devise
    module InvitationsControllerOverride
      extend ActiveSupport::Concern

      included do
        # GET /resource/invitation/accept?invitation_token=abcdef
        def edit
          set_minimum_password_length
          resource.invitation_token = params[:invitation_token]

          if cas_user?
            redirect_to new_user_cas_session_path
          else
            render :edit
          end
        end

        private

        def cas_user?
          Decidim::ParticipatorySpacePrivateUser.find_by(user: resource, cas_user: true)
        end
      end
    end
  end
end
