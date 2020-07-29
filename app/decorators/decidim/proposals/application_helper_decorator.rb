# frozen_string_literal: true

Decidim::Proposals::ApplicationHelper.class_eval do
  # Override
  def safe_content?
    true
  end  
end