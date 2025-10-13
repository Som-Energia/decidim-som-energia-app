# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20180407110934)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:10 UTC
class AddServicesToMeetings < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_meetings_meetings, :services, :jsonb, default: []
  end
end
