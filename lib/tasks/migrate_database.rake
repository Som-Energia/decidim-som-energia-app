# frozen_string_literal: true

require_relative "script_helpers"

namespace :som do
  desc "Export database"
  task export_database: :environment do
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

    export_participatory_process(export_dir)

    export_assemblies(export_dir)
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
        admin.serializable_hash
        csv << admin.attributes.values
      end
    end

    puts "Done exporting system administators. You can find them in #{path}"
  end

  def export_organizations(export_dir)
    organizations = Decidim::Organization.all
    puts "Exporting organizations: #{organizations.count}"
    path = export_dir.join("organizations.json")
    organizations.each do |o|
      puts "Exporting organization: #{o.id} - #{o.name}"
      # attributes = ["id", "name", "host", "default_locale", "available_locales", "created_at", "updated_at", "description",  "twitte
      except_attributes = %w(logo favicon highlighted_content_banner_image official_img_header official_img_footer)
      json_object = o.serializable_hash

      data = JSON.pretty_generate(json_object)
      File.write(path, data)
    end
    puts "Done exporting organizations. You can find them in #{path}"
  end

  def export_organizations_two(export_dir)
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
            .where.not(decidim_participatory_space_id: nil)
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

  def export_participatory_process(export_dir)
    path = export_dir.join("processes.csv")

    participatory_processes_slugs = ["AGE2025",
                                     "RedifinicioRRI",
                                     "SomAG2024",
                                     "granconversa",
                                     "SomAG2023",
                                     "SomAG2022",
                                     "desempat",
                                     "SomAG2021",
                                     "SomAG2020",
                                     "escola2019",
                                     "ilustrabonaenergia",
                                     "SomAG2019",
                                     "redisseny-imatge-de-marca",
                                     "somdebatxs",
                                     "somescola2018",
                                     "SomAG2018"]

    processes = Decidim::ParticipatoryProcess.where(slug: participatory_processes_slugs)

    puts "Exporting participatory processes: #{processes.count}"

    CSV.open(path, "wb") do |csv|
      csv << Decidim::ParticipatoryProcess.attribute_names
      processes.each do |process|
        csv << process.attributes.values
      end
    end

    puts "Done exporting participatory processes. You can find them in #{path}"
  end

  def export_assemblies(export_dir)
    path = export_dir.join("assemblies.csv")

    assemblies_slugs = %w(impagaments
                          monedasocial
                          agrovoltaica
                          ppcomunidadlocal
                          ppPPPAs
                          flexcoop
                          GL
                          et
                          cr)

    assemblies = Decidim::Assembly.where(slug: assemblies_slugs)
    puts "Exporting assemblies: #{assemblies.count}"

    CSV.open(path, "wb") do |csv|
      csv << Decidim::Assembly.attribute_names

      assemblies.each do |assembly|
        csv << assembly.attributes.values
      end
    end

    puts "Done exporting assemblies. You can find them in #{path}"
  end
end
