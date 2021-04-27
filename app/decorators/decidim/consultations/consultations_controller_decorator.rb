# frozen_string_literal: true

Decidim::Consultations::ConsultationsController.class_eval do
  private

  def default_filter_params
    {
      search_text: "",
      state: "all",
      highlighted_scope_ids: ""
    }
  end
end
