# frozen_string_literal: true

# This migration comes from decidim_budgets (originally 20200629134013)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:10 UTC
class AddBudgetReferenceToProject < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_budgets_projects, :decidim_budgets_budget, foreign_key: true
  end
end
