# frozen_string_literal: true

module SomEnergia
  module Consultations
    module Admin
      # A form object used to create questions for a consultation from the admin dashboard.
      module QuestionConfigurationFormOverride
        extend ActiveSupport::Concern

        included do
          include Decidim::AttributeObject

          attribute :enforce_special_requirements, :boolean, default: false
        end
      end
    end
  end
end
