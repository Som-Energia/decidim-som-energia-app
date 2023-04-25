# frozen_string_literal: true

module SomEnergia
  module Consultations
    module Admin
      module CreateResponseOverride
        extend ActiveSupport::Concern

        included do
          def create_response
            Decidim::Consultations::Response.create(
              question: form.context.current_question,
              title: form.title,
              response_group: form.response_group,
              weight: form.weight
            )
          end
        end
      end
    end
  end
end
