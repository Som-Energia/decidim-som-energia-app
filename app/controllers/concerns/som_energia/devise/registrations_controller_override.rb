# frozen_string_literal: true

module SomEnergia
  module Devise
    module RegistrationsControllerOverride
      extend ActiveSupport::Concern

      included do
        before_action do
          redirect_to new_user_session_path
        end
      end
    end
  end
end
