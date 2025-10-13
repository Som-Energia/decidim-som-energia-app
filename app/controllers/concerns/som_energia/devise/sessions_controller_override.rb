# frozen_string_literal: true

module SomEnergia
  module Devise
    module SessionsControllerOverride
      extend ActiveSupport::Concern

      included do
        def after_sign_out_path_for(user)
          # Redirect to the CAS logout URL if the user is logged in via CAS
          cas_logout_url = ENV.fetch("CAS_LOGOUT_URL", nil)
          return "#{cas_logout_url}?service=#{request.base_url}" if cas_logout_url.present?

          # Fallback to the referer or the default path
          request.referer || super
        end
      end
    end
  end
end
