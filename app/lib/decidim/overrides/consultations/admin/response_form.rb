# frozen_string_literal: true

module Decidim
  module Overrides
    module Consultations
      module Admin
        # A form object used to create responses for a question from the admin dashboard.
        module ResponseForm
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
