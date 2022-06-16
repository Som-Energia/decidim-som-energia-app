# frozen_string_literal: true

module Decidim
  module Overrides
    module Consultations
      module Admin
        module UpdateQuestionConfiguration
          def attributes
            super_attributes = super
            super_attributes[:enforce_special_requirements] = form.enforce_special_requirements
            super_attributes
          end
        end
      end
    end
  end
end
