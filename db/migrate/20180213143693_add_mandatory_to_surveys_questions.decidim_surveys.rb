# frozen_string_literal: true

# This migration comes from decidim_surveys (originally 20170522075938)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:11 UTC
class AddMandatoryToSurveysQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_surveys_survey_questions, :mandatory, :boolean
  end
end
