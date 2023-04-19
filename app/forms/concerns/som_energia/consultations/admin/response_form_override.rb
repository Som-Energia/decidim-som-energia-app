# frozen_string_literal: true

module SomEnergia
  module Overrides
    module Consultations
      module Admin
        # A form object used to create responses for a question from the admin dashboard.
        module ResponseFormOverride
          def self.prepended(base)
            base.class_eval do
              attribute :weight, base::Integer, default: 0
            end
          end
        end
      end
    end
  end
end
