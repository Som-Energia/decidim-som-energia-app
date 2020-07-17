# frozen_string_literal: true

Decidim::Proposals::Orderable.class_eval do
  # Method override
  # Gets how the proposals should be ordered based on the choice
  # made by the user.
  def order
    @order ||= detect_order(session[:order]) || default_order
  end
end
