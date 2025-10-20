# frozen_string_literal: true

module SomEnergia
  module ActivityCellOverride
    extend ActiveSupport::Concern

    included do
      alias_method :original_show, :show

      def show
        original_show
      rescue NoMethodError => e
        # Soft-deleted components or participatory spaces could cause errors
        # when rendering activities. We log them for further inspection but
        # avoid breaking the entire activity feed.
        Rails.logger.error("Error rendering activity cell for #{model.id}: #{e.message}")
        nil
      end
    end
  end
end
