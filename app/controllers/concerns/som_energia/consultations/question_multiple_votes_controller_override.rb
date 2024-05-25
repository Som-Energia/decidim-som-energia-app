# frozen_string_literal: true

module SomEnergia
  module Consultations
    module QuestionMultipleVotesControllerOverride
      extend ActiveSupport::Concern

      included do
        # rubocop:disable Rails/LexicallyScopedActionFilter
        before_action :transform_params, only: :create
        # rubocop:enable Rails/LexicallyScopedActionFilter

        private

        def transform_params
          params["responses"] = params["responses"].values.flatten if params["responses"].respond_to? :values
        end
      end
    end
  end
end
