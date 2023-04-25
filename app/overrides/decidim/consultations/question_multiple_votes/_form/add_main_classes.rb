# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/consultations/question_multiple_votes/_form",
                     set_attributes: "div.card[1]",
                     attributes: {
                       class: "card js-card-grouped-response js-group-not-answered",
                       title: "grouped-response-<%= group&.id %>"
                     })
