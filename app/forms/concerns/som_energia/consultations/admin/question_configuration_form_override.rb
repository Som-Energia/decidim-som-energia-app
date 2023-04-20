# frozen_string_literal: true

module SomEnergia
  module Consultations
    module Admin
      # A form object used to create questions for a consultation from the admin dashboard.
      module QuestionConfigurationFormOverride
        extend ActiveSupport::Concern

        included do
          attribute :enforce_special_requirements, Virtus::Attribute::Boolean, default: false
        end
      end
    end
  end
end
