# frozen_string_literal: true

module Decidim
  module Overrides
    module Consultations
      module Admin
        # A form object used to create questions for a consultation from the admin dashboard.
        module QuestionConfigurationForm
          def self.prepended(base)
            base.class_eval do
              attribute :enforce_special_requirements, base::Boolean, default: false
            end
          end
        end
      end
    end
  end
end
