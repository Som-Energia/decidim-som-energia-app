# frozen_string_literal: true

module SomEnergia
  module ConsultationOverride
    extend ActiveSupport::Concern

    included do
      scope :highlighted_scope_ids, lambda { |*args|
        highlighted_scope_ids = args.flatten.compact.reject(&:empty?)
        if highlighted_scope_ids.any?
          size = highlighted_scope_ids.size
          condition = "? = ANY(decidim_scopes.part_of)"
          conditions = Array.new(size, condition).join(" OR ")
          includes(:highlighted_scope)
            .references(:decidim_scopes)
            .where(conditions, *highlighted_scope_ids)
        end
      }

      def self.ransackable_scopes(_auth_object = nil)
        [:with_any_date, :highlighted_scope_ids]
      end
    end
  end
end
