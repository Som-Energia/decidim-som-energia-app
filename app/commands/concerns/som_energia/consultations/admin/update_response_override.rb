# frozen_string_literal: true

module SomEnergia
  module Consultations
    module Admin
      module UpdateResponseOverride
        extend ActiveSupport::Concern

        included do
          def attributes
            {
              title: form.title,
              response_group: form.response_group,
              weight: form.weight
            }
          end
        end
      end
    end
  end
end
