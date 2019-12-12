# frozen_string_literal: true

# This decorator changes the value of the key :state in default_filter_params Hash.
Decidim::Initiatives::InitiativesController.class_eval do
  SIGNATURE_START_DATE = Date.new(2020, 2, 1).in_time_zone

  alias original_default_filter_params default_filter_params

  # Method overrided.
  # Assigns the value "closed" to the :state key until the given date is reached.
  def default_filter_params
    original_default_filter_params.tap do |hash|
      hash[:state] = "closed" if Time.current < SIGNATURE_START_DATE
    end
  end
end
