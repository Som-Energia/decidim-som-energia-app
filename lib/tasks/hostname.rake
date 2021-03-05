# frozen_string_literal: true

namespace :hostname do
  task to_staging: :environment do
    organization = Decidim::Organization.find_by host: "participa.somenergia.coop"
    if organization
      organization.host = "staging.participa.somenergia.coop"
      organization.save!
      puts "changed organization host for #{organization.id} to staging.participa.somenergia.coop"
    else
      puts "Organization participa.somenergia.coop not found!"
    end
  end
end
