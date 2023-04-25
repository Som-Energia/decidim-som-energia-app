# frozen_string_literal: true

module SomEnergia
  module Consultations
    module Admin
      module UpdateQuestionConfigurationOverride
        extend ActiveSupport::Concern

        included do
          def attributes
            {
              max_votes: form.max_votes,
              min_votes: form.min_votes,
              instructions: form.instructions,
              enforce_special_requirements: form.enforce_special_requirements
            }
          end
        end
      end
    end
  end
end
