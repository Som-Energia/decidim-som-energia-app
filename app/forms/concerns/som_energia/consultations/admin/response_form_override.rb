# frozen_string_literal: true

module SomEnergia
  module Consultations
    module Admin
      # A form object used to create responses for a question from the admin dashboard.
      module ResponseFormOverride
        extend ActiveSupport::Concern

        included do
          attribute :weight, Integer, default: 0
        end
      end
    end
  end
end
