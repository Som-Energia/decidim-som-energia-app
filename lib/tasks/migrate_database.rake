# frozen_string_literal: true

require_relative "script_helpers"

namespace :som do
  desc "Export database"
  task export_database: :environment do
    puts "Going to export the folloding content of the database:"
    puts "- Users that have participied in the given processes"
    puts "- Proposals inside the components of the processes"
    puts "- Meetings inside the components of the processes"
    puts "- Comments inside the components of the processes"

    export_dir = Rails.root.join("tmp", "decidim_export")
    Dir.mkdir export_dir unless Dir.exist?(export_dir)

    export_users(export_dir)

    export_proposals(export_dir)

    export_meetings(export_dir)

    export_comments(export_dir)
  end

  desc "Import database"
  task import_database: :environment do
    puts "Going to import the folloding models:"
    puts "- Users that have participied in the processes: tmp/decidim_export/users.csv"
    puts "- Meetings: tmp/decidim_export/meetings.csv"
    puts "- Proposals: tmp/decidim_export/proposals.csv"
    puts "- Comments: tmp/decidim_export/comments.csv"

    import_dir = Rails.root.join("tmp", "decidim_export")

    import_users(import_dir)

    import_meetings(import_dir)

    import_proposals(import_dir)

    import_comments(import_dir)
  end

  def export_meetings(export_dir)
    path = export_dir.join("meetings.csv")

    slugs = all_slugs

    CSV.open(path, "wb") do |csv|
      csv << (Decidim::Meetings::Meeting.attribute_names + %w(space_slug space_type component_name))

      meetings = Decidim::Meetings::Meeting.all
      puts "Exporting meetings"
      count = 0

      meetings.each do |meeting|
        space = meeting.try(:participatory_space)
        next unless space.slug.in? slugs

        component = meeting.component
        name = component.name
        csv << (meeting.attributes.values + [space.slug, space.class.name, name["ca"]])
        count += 1
      end

      puts "Exported #{count} meetings. You can find them in #{path}"
    end
  end

  def export_comments(export_dir)
    path = export_dir.join("comments.csv")

    slugs = all_slugs
    count = 0

    CSV.open(path, "wb") do |csv|
      csv << (Decidim::Comments::Comment.attribute_names + %w(space_slug author_email commentable_type commentable_id component_title))

      comments = Decidim::Comments::Comment.includes(:author, commentable: :participatory_space)

      comments.each do |comment|
        space = comment.commentable.try(:participatory_space)
        title = comment.commentable.try(:title)
        title_ca = title["ca"] unless title.nil?

        commentable_type = comment.decidim_commentable_type
        commentable_id = comment.decidim_commentable_id
        next unless space&.slug.in?(slugs)

        csv << (comment.attributes.values + [space.slug, comment.author.email, commentable_type, commentable_id, title_ca]) if space&.slug.in?(slugs)

        count += 1
      end

      puts "Exported #{count} comments. Tou can find them in #{path}"
    end
  end

  def export_users(export_dir)
    path = export_dir.join("users.csv")
    slugs = all_slugs
    users = []

    comments = Decidim::Comments::Comment.includes(commentable: :participatory_space)
    comments.each do |comment|
      space = comment.commentable.try(:participatory_space)
      users << comment.author if space&.slug.in?(slugs)
    end

    users.uniq!

    puts "Exporting users: #{users.count}"

    CSV.open(path, "wb") do |csv|
      csv << Decidim::User.attribute_names
      users.each do |user|
        csv << user.attributes.values
      end
    end

    puts "Done exporting users. You can find them in #{path}"
  end

  def export_proposals(export_dir)
    path = export_dir.join("proposals.csv")

    slugs = all_slugs

    count = 0
    puts "Exporting proposals."
    CSV.open(path, "wb") do |csv|
      csv << (Decidim::Proposals::Proposal.attribute_names + %w(space_slug space_type component_name))

      proposals = Decidim::Proposals::Proposal.all
      proposals.each do |proposal|
        next unless proposal.participatory_space&.slug.in? all_slugs

        space = proposal.participatory_space
        component_name = proposal.component.name["ca"]

        csv << (proposal.attributes.values + [space.slug, space.class.name, component_name]) if space&.slug.in?(slugs)
        count += 1
      end
    end

    puts "Done exporting #{count} proposals. You can find them in #{path}"
  end

  def import_users(import_dir)
    path = import_dir.join("users.csv")

    organization = Decidim::Organization.first
    csv = CSV.parse(File.read(path), headers: true)
    csv.each do |row|
      unless Decidim::User.where("email = :email OR nickname = :nickname", email: row["email"], nickname: row["nickname"])
        user = Decidim::User.new(name: row["name"], email: row["email"], accepted_tos_version: Time.current, nickname: row["nickname"],
                                 organization: organization)
      end
      next unless user

      user.skip_invitation = true
      user.invite!
    end
  end

  def import_comments(import_dir)
    path = import_dir.join("comments.csv")

    csv = CSV.parse(File.read(path), headers: true)
    count = 0

    csv.each do |row|
      space_slug = row["space_slug"]
      author_email = row["author_email"]
      component_title = row["component_title"]
      commentable_type = row["commentable_type"]
      commentable_id = row["commentable_id"]

      row.delete("space_slug")
      row.delete("author_email")
      row.delete("component_title")
      row.delete("commentable_type")
      row.delete("commentable_id")

      begin
        commentable = commentable_type&.constantize.find(commentable_id)
      rescue StandardError => e
        puts "Could not find commentable #{commentable_type} #{commentable_id}"
        next
      end

      author = Decidim::User.find_by(email: author_email)
      # component = Decidim::Component.find_by("name ->> 'ca' = ?", component_title)

      if commentable_type != Decidim::Comments::Comment.class.name
        space_type = row["decidim_participatory_space_type"]
        begin
          space = space_type.constantize.find_by(slug: space_slug)
        rescue NoMethodError => e
          puts "There is no space_type in comment #{row["id"]} #{row["component_title"]}"
        end
      end

      comment = Decidim::Comments::Comment.new(row.to_hash)
      comment.body = eval(row["body"])
      comment.author = author
      comment.commentable = commentable
      begin
        comment.save!
        count += 1
      rescue StandardError => e
        puts "Could not import comment #{comment.id}"
        puts e
      end
    end

    puts "Imported #{count} comments"
  end

  def import_meetings(import_dir)
    path = import_dir.join("meetings.csv")

    imported = 0
    csv = CSV.parse(File.read(path), headers: true)
    csv.each do |row|
      space_slug = row["space_slug"]
      component_name = row["component_name"]

      component = Decidim::Component.find_by("name ->> 'ca' = ?", component_name)
      next unless component

      row.delete("component_name")
      row.delete("space_slug")
      row.delete("space_type")
      row.delete("reminder_enabled")
      row.delete("send_reminders_before_hours")
      row.delete("reminder_message_custom_content")
      row.delete("waitlist_enabled")

      meeting = Decidim::Meetings::Meeting.new(row.to_hash)
      meeting.title = eval(row["title"])
      meeting.description = eval(row["description"])
      meeting.location = eval(row["location"])
      meeting.location_hints = eval(row["location_hints"])
      meeting.registration_terms = eval(row["registration_terms"])
      meeting.component = component
      meeting.save!

      imported += 1
    end

    puts "Imported #{imported} meetings."
  end

  def import_proposals(import_dir)
    path = import_dir.join("proposals.csv")

    csv = CSV.parse(File.read(path), headers: true)
    csv.each do |row|
      space_slug = row["space_slug"]
      space_type = row["space_type"]
      component_name = row["component_name"]

      space = space_type.constantize.find_by(slug: space_slug)
      next unless space

      component = Decidim::Component.find_by("name ->> 'ca' = ?", component_name)
      next unless component

      row.delete("space_slug")
      row.delete("space_type")
      row.delete("component_name")

      proposal = Decidim::Proposals::Proposal.new(row.to_hash)
      proposal.component = component
      proposal.title = eval(row["title"])
      proposal.body = eval(row["body"])
      byebug

      proposal.save!

      imported += 1
    end

    puts "Imported #{imported} meetings."
  end

  def all_slugs
    assemblies_slugs = %w(impagaments
                          monedasocial
                          agrovoltaica
                          ppcomunidadlocal
                          ppPPPAs
                          flexcoop
                          GL
                          et
                          cr)

    participatory_processes_slugs = %w(AGE2025
                                       RedifinicioRRI
                                       SomAG2024
                                       granconversa
                                       SomAG2023
                                       SomAG2022
                                       desempat
                                       SomAG2021
                                       SomAG2020
                                       escola2019
                                       ilustrabonaenergia
                                       SomAG2019
                                       redisseny-imatge-de-marca
                                       somdebatxs
                                       somescola2018
                                       SomAG2018)

    assemblies_slugs + participatory_processes_slugs
  end
end
