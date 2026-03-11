# frozen_string_literal: true

# Somehow it seems that the attribute "body" has been transformed to jsonb, it should be text
class FixBodyOnFormsResponses < ActiveRecord::Migration[7.2]
  def change
    change_column :decidim_forms_responses, :body, :text, null: true, default: nil
  end
end
