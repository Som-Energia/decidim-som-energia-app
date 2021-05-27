# frozen_string_literal: true

Decidim::Consultations::ConsultationsController.class_eval do
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
      search_text: "",
      state: "all",
      highlighted_scope_ids: ""
    }
  end
end
