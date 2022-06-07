class AddSpecialRequirementsToDecidimConsultationsQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_consultations_questions, :enforce_special_requirements, :boolean
  end
end
