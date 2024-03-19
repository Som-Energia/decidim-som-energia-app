# frozen_string_literal: true

module SomEnergia
  module Proposals
    module ProposalsControllerOverride
      extend ActiveSupport::Concern

      included do
        before_action only: [:index] do
          response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
          response.headers["Pragma"] = "no-cache"
          response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
        end

        def show
          raise ActionController::RoutingError, "Not Found" if @proposal.blank? || !can_show_proposal?

          @report_form = form(Decidim::ReportForm).from_params(reason: "spam")
        end
      end
    end
  end
end
