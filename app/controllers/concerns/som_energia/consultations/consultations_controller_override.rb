# frozen_string_literal: true

module SomEnergia
  module Consultations
    module ConsultationsControllerOverride
      extend ActiveSupport::Concern

      included do
        private

        # Available orders based on enabled settings
        def available_orders
          %w(recent random)
        end

        def default_order
          "recent"
        end

        def default_filter_params
          {
            search_text_cont: "",
            state: "all",
            highlighted_scope_ids: ""
          }
        end
      end
    end
  end
end
