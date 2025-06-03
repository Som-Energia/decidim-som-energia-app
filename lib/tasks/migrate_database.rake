# frozen_string_literal: true

require_relative "script_helpers"

namespace :som do

  desc "Export database"
  task :export_database => :environment do
    puts "Going to export the folloding content of the database:"
    puts "- System administrators"
    puts "- Organizations"
    puts "- Users that have participied in the processes"
    puts "- Participatory processes"

    export_dir = Rails.root.join("tmp", "decidim_export")
    Dir.mkdir export_dir unless Dir.exist?(export_dir)

    export_system_admins(export_dir)

    export_organizations(export_dir)

    export_users(export_dir)

  end

  desc "Import database"
  task :import_database, :environment do

  end

  def export_system_admins(export_dir)
    path = export_dir.join("system_admins.csv")

    CSV.open(path, "wb") do |csv|
      system_admins = Decidim::System::Admin.all
      puts "Exporting system administrators: #{system_admins.count}"
      csv << Decidim::System::Admin.attribute_names

      system_admins.each do |admin|
        csv << admin.attributes.values
      end
    end

    puts "Done exporting system administators. You can find them in #{path}"
  end

  def export_organizations(export_dir)
    organizations = Decidim::Organization.all
    puts "Exporting organizations: #{organizations.count}"

    path = export_dir.join("organizations.csv")

    CSV.open(path, "wb") do |csv|
      csv << Decidim::Organization.attribute_names
      organizations.each do |organization|
        csv << organization.attributes.values
      end
    end

    puts "Done exporting organizations. You can find them in #{path}"
  end

  def export_users(export_dir)
    path = export_dir.join("users.csv")
    users = Decidim::User
      .joins("INNER JOIN decidim_comments_comments c on c.decidim_author_id = decidim_users.id")
      .joins("LEFT JOIN decidim_assemblies a ON a.id = decidim_participatory_space_id and decidim_participatory_space_type = 'Decidim::Assembly'")
      .joins("LEFT JOIN decidim_participatory_processes p ON p.id = decidim_participatory_space_id and decidim_participatory_space_type = 'Decidim::ParticipatoryProcess'")
      .where("decidim_participatory_space_id IS NOT NULL")
      .uniq

    puts "Exporting users: #{users.count}"

    CSV.open(path, "wb") do |csv|
      csv << Decidim::User.attribute_names
      users.each do |user|
        csv << user.attributes.values
      end
    end

    puts "Done exporting users. You can find them in #{path}"
  end
end
