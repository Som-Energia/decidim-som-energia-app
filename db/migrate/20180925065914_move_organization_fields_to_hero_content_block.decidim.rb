# frozen_string_literal: true
# This migration comes from decidim (originally 20180810092428)

class MoveOrganizationFieldsToHeroContentBlock < ActiveRecord::Migration[5.2]
  class ::Decidim::Organization < Decidim::ApplicationRecord
  end

  def change
    Decidim::ContentBlock.reset_column_information
    Decidim::Organization.find_each do |organization|
      content_block = Decidim::ContentBlock.find_by(organization: organization, scope: :homepage, manifest_name: :hero)
      settings = {}
      welcome_text = organization.welcome_text || {}
      settings = welcome_text.inject(settings) { |acc, (k, v)| acc.update("welcome_text_#{k}" => v) }

      content_block.settings = settings
      content_block.images_container.background_image = organization.homepage_image.file
      content_block.settings_will_change!
      content_block.images_will_change!
      content_block.save!
    end

    remove_column :decidim_organizations, :welcome_text
    remove_column :decidim_organizations, :homepage_image
  end
end
