# frozen_string_literal: true

module Decidim
  module Overrides
    module Consultations
      module Admin
        module CreateResponse
          def create_response
            Response.create(
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
