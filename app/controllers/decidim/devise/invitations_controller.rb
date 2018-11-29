# frozen_string_literal: true

module Decidim
  module Devise
    # This controller customizes the behaviour of Devise::Invitiable.
    class InvitationsController < ::Devise::InvitationsController
      before_action :force_redirect

      private

      def force_redirect
        redirect_to new_user_session_path
      end
    end
  end
end
