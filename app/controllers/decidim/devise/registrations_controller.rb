# frozen_string_literal: true

module Decidim
  module Devise
    class RegistrationsController < ::Devise::RegistrationsController
      before_action :force_redirect

      private

      def force_redirect
        redirect_to new_user_session_path
      end

    end
  end
end
