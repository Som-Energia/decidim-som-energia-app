# frozen_string_literal: true

module Decidim
  module Consultations
    class ConsultationSummariesController < Decidim::Consultations::ConsultationsController
      def show
        enforce_permission_to :read, :consultation, consultation: current_consultation

        render layout: "layouts/decidim/consultation_summary"
      end

      def preview
        @consultation = OrganizationConsultations.for(current_organization).sample

        render layout: false
      end
    end
  end
end
