# frozen_string_literal: true

Decidim::Consultations::ConsultationSearch.class_eval do
  def search_highlighted_scope_ids
    size = highlighted_scope_ids.size
    condition = "? = ANY(decidim_scopes.part_of)"
    conditions = Array.new(size, condition).join(" OR ")

    query
      .includes(:highlighted_scope)
      .references(:decidim_scopes)
      .where(conditions, *highlighted_scope_ids)
  end
end
