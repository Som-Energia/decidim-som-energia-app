# frozen_string_literal: true

# module SomEnergia
#   module Consultations
#     module ConsultationSearchOverride
#       extend ActiveSupport::Concern
#
#       included do
#         def search_highlighted_scope_ids
#           size = highlighted_scope_ids.size
#           condition = "? = ANY(decidim_scopes.part_of)"
#           conditions = Array.new(size, condition).join(" OR ")
#
#           query
#             .includes(:highlighted_scope)
#             .references(:decidim_scopes)
#             .where(conditions, *highlighted_scope_ids)
#         end
#       end
#     end
#   end
# end
