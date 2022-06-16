class AddWeightToDecidimConsultationsResponses < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_consultations_responses, :weight, :integer, null: false, default: 0
  end
end
