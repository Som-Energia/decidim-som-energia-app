# frozen_string_literal: true

module SomEnergia
  module ConsultationOverride
    extend ActiveSupport::Concern

    included do
      scope :search_highlighted_scope_ids, lambda { |highlighted_scope_ids|
        size = highlighted_scope_ids.size
        condition = "? = ANY(decidim_scopes.part_of)"
        conditions = Array.new(size, condition).join(" OR ")

        includes(:highlighted_scope)
          .references(:decidim_scopes)
          .where(conditions, *highlighted_scope_ids)
      }
    end
  end
end
