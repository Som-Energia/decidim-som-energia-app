# frozen_string_literal: true

# This contoller ensures that the user is logged out from the CAS server
module SomEnergia
  class SessionsController < ::Devise::SessionsController
    def destroy
      reset_session

      strategy = OmniAuth::Strategies::CAS.new(nil, host: ENV.fetch("CAS_HOST", nil))
      return_url = request.referer.presence || decidim.root_path
      redirect_to strategy.cas_url + strategy.append_params("/logout", service: return_url)
    end
  end
end
