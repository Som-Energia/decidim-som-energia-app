# frozen_string_literal: true

module SomEnergia
  module Initiatives
    module InitiativesControllerOverride
      extend ActiveSupport::Concern

      included do
        # This is the date that the Product Owner has chosen. See docs/overrides.md
        SIGNATURE_START_DATE = Date.new(2020, 2, 1).in_time_zone

        alias_method :original_default_filter_params, :default_filter_params

        # Method overrided.
        # Assigns the value "closed" to the :state key after the given date is reached.
        def default_filter_params
          original_default_filter_params.tap do |default_params|
            default_params[:state] = ["closed"] if Time.current > SIGNATURE_START_DATE
          end
        end
      end
    end
  end
end
