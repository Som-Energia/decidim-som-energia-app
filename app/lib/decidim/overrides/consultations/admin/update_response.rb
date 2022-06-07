# frozen_string_literal: true

module Decidim
  module Overrides
    module Consultations
      module Admin
        module UpdateResponse
          def attributes
            super_attributes = super
            super_attributes[:weight] = form.weight
            super_attributes
          end
        end
      end
    end
  end
end
