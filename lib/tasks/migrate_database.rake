# frozen_string_literal: true

#
# rubocop: disable Security/Eval

require_relative "script_helpers"

namespace :som do
  desc "Export database"
  task export_database: :environment do
    puts "Going to export the folloding content of the database:"
    puts "- Users that have participied in the given processes"
    puts "- Proposals inside the components of the processes"
    puts "- Meetings inside the components of the processes"
    puts "- Comments inside the components of the processes"

    export_dir = Rails.root.join("tmp/decidim_export")
    Dir.mkdir export_dir unless Dir.exist?(export_dir)

    export_scopes_types(export_dir)

    export_scopes(export_dir)

    export_pages(export_dir)

    export_posts(export_dir)

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

    import_dir = Rails.root.join("tmp/decidim_export")
    import_scope_types(import_dir)

    import_scopes(import_dir)

    import_users(import_dir)

    import_meetings(import_dir)

    import_posts(import_dir)

    import_pages(import_dir)

    import_proposals(import_dir)

    import_comments(import_dir)
  end

  desc "Import Comments"
  task import_comments: :environment do
    import_dir = Rails.root.join("tmp/decidim_export")

    import_comments(import_dir)
  end

  desc "Import Proposals"
  task import_proposals: :environment do
    import_dir = Rails.root.join("tmp/decidim_export")

    import_proposals(import_dir)
  end

  desc "Import Pages"
  task import_pages: :environment do
    import_dir = Rails.root.join("tmp/decidim_export")

    import_pages(import_dir)
  end

  desc "Import Scopes"
  task import_scopes: :environment do
    import_dir = Rails.root.join("tmp/decidim_export")

    import_scope_types(import_dir)
    import_scopes(import_dir)
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

  def export_pages(export_dir)
    path = export_dir.join("pages.csv")

    pages = Decidim::Pages::Page.all
    puts "Exporting pages"

    count = 0
    CSV.open(path, "wb") do |csv|
      csv << (Decidim::Pages::Page.attribute_names + %w(component_name))

      pages.each do |page|
        next unless page.component.participatory_space.slug.in? all_slugs

        component_name = page.component.name["ca"]
        csv << (page.attributes.values + [component_name])
        count += 1
      end
    end

    puts "Exported #{count} pages. You can find them in #{path}"
  end

  def export_scopes_types(export_dir)
    path = export_dir.join("scopes_types.csv")

    scopes_types = Decidim::ScopeType.all

    count = 0
    CSV.open(path, "wb") do |csv|
      csv << (Decidim::ScopeType.attribute_names)

      scopes_types.each do |scope_type|
        csv << (scope_type.attributes.values)

        count += 1
      end
    end

    puts "Exported #{count} scope types. You can find them in #{path}"
  end

  def export_posts(export_dir)
    path = export_dir.join("posts.csv")

    posts = Decidim::Blogs::Post.all

    count = 0
    CSV.open(path, "wb") do |csv|
      csv << (Decidim::Blogs::Post.attribute_names + %w(component_name author_email))

      posts.each do |post|
        next unless post.component.participatory_space.slug.in? all_slugs

        component = post.component.name["ca"]
        author = post.author.email
        csv << (post.attributes.values + [component, author])
        count += 1
      end
    end

    puts "Exproted #{count} blog posts. You can find them in #{path}"
  end

  def export_scopes(export_dir)
    path = export_dir.join("scopes.csv")

    scopes = Decidim::Scope.where(organization: Decidim::Organization.first)

    count = 0
    CSV.open(path, "wb") do |csv|
      csv << (Decidim::Scope.attribute_names)

      scopes.each do |scope|
        csv << (scope.attributes.values)

        count += 1
      end

      puts "Exported #{count} scopes. You can find them in #{path}"
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

      puts "Exported #{count} comments. You can find them in #{path}"
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

    proposals = Decidim::Proposals::Proposal.all
    proposals.each do |proposal|
      space = proposal.participatory_space
      author = proposal.coauthorships.first.author
      users << author if proposal.coauthorships.first.decidim_author_type == Decidim::UserBaseEntity.name && space&.slug.in?(slugs)
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
      csv << (Decidim::Proposals::Proposal.attribute_names + %w(space_slug space_type component_name author_type author_email))

      proposals = Decidim::Proposals::Proposal.all
      proposals.each do |proposal|
        next unless proposal.participatory_space&.slug.in? all_slugs

        space = proposal.participatory_space
        component_name = proposal.component.name["ca"]
        author_type = proposal.coauthorships.first.decidim_author_type
        author_email = proposal.coauthorships.first.author.email if author_type == Decidim::UserBaseEntity.name

        csv << (proposal.attributes.values + [space.slug, space.class.name, component_name, author_type, author_email]) if space&.slug.in?(slugs)
        count += 1
      end
    end

    puts "Done exporting #{count} proposals. You can find them in #{path}"
  end

  def import_users(import_dir)
    path = import_dir.join("users.csv")

    organization = Decidim::Organization.first
    csv = CSV.parse(File.read(path), headers: true)
    puts "Importing users: #{csv.length}"
    count = 0
    already_exists = 0

    csv.each do |row|
      exists_user = Decidim::User.where("email = :email OR nickname = :nickname", email: row["email"], nickname: row["nickname"])

      if exists_user.empty?
        user = Decidim::User.new(name: row["name"], email: row["email"], accepted_tos_version: Time.current, nickname: row["nickname"],
                                 organization: organization)
      end

      unless user
        already_exists += 1
        next
      end

      user.skip_invitation = true
      user.invite!
      user.save
      count += 1
    end

    puts "Done importing users: #{count} - #{already_exists} already existed"
  end

  def import_comments(import_dir)
    path = import_dir.join("comments.csv")

    csv = CSV.parse(File.read(path), headers: true)
    count = 0
    could_not_import = 0

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
        commentable_type = "Decidim::Debates::Debate" if commentable_type == "Decidim::Proposals::Proposal" && space_slug == "somdebatxs"

        commentable = if commentable_type == "Decidim::Consultations::Question"
                        Decidim::Consultations::Question.find_by("title ->> 'ca' = ?", component_title)
                      else
                        commentable_type.constantize.find(commentable_id)
                      end
      rescue StandardError => e
        puts "Could not find commentable #{commentable_type} #{commentable_id}"
        puts e
        could_not_import += 1
        next
      end

      author = Decidim::User.find_by(email: author_email)
      # component = Decidim::Component.find_by("name ->> 'ca' = ?", component_title)

      comment = Decidim::Comments::Comment.new(row.to_hash)
      comment.body = eval(row["body"])
      comment.author = author
      comment.commentable = commentable
      root_commentable = if commentable_type == "Decidim::Comments::Comment"
                           commentable.commentable
                         else
                           commentable
                         end
      comment.root_commentable = root_commentable
      begin
        comment.save!
        count += 1
      rescue StandardError => e
        puts "Could not import comment #{comment.id}"
        could_not_import += 1
        puts e
      end
    end

    puts "Imported #{count} comments. Could not import #{could_not_import}"
  end

  def import_meetings(import_dir)
    path = import_dir.join("meetings.csv")

    imported = 0
    csv = CSV.parse(File.read(path), headers: true)
    csv.each do |row|
      # space_slug = row["space_slug"]
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
    imported = 0
    could_not_import = 0

    puts "Importing proposals #{csv.length}"
    csv.each do |row|
      space_slug = row["space_slug"]
      space_type = row["space_type"]
      component_name = row["component_name"]

      author_type = row["author_type"]
      author_email = row["author_email"]
      author = if author_type == Decidim::Organization.name
                 Decidim::Organization.first
               else
                 Decidim::User.find_by(email: author_email)
               end

      if space_slug == "somdebatxs"

        if Decidim::Debates::Debate.find_by(id: row["id"])
          puts "Debate #{row["id"]} already exists"
          imported += 1
          next
        end

        space = Decidim::Assembly.find_by(slug: space_slug)
        body = row["body"]
        row.delete("space_slug")
        row.delete("space_type")
        row.delete("component_name")
        row.delete("author_type")
        row.delete("author_email")
        row.delete("proposal_votes_count")
        row.delete("state")
        row.delete("answered_at")
        row.delete("answer")
        row.delete("address")
        row.delete("latitude")
        row.delete("longitude")
        row.delete("proposal_notes_count")
        row.delete("published_at")
        row.delete("coauthorships_count")
        row.delete("participatory_text_level")
        row.delete("position")
        row.delete("created_in_meeting")
        row.delete("cost")
        row.delete("cost_report")
        row.delete("execution_period")
        row.delete("state_published_at")
        row.delete("body")
        row.delete("valuation_assignments_count")

        component = Decidim::Component.where("name ->> 'ca' = ?", component_name).where(participatory_space: space).first
        puts "could not find component with name #{component_name}" unless component
        unless component
          could_not_import += 1
          next
        end

        debate = Decidim::Debates::Debate.new(row.to_hash)

        debate.component = component
        debate.title = eval(row["title"])
        debate.description = eval(body)
        debate.author = author

        unless debate.save
          puts "Could not import debate. #{debate.id} - #{debnate.title}"
          could_not_import += 1
          puts debate.errors.full_messages
          next
        end

        imported += 1
        next
      end

      space = space_type.constantize.find_by(slug: space_slug)
      space ||= Decidim::ParticipatoryProcess.find_by(slug: space_slug)
      puts "could not find space: #{space_slug}" unless space
      unless space
        puts "Could not import Proposal. #{row["id"]} #{row["title"]}"
        could_not_import += 1
        next
      end

      component = Decidim::Component.where("name ->> 'ca' = ?", component_name).where(participatory_space: space).first
      puts "could not find component with name #{component_name}" unless component
      unless component
        puts "Could not import Proposal. #{row["id"]} #{row["title"]}"
        could_not_import += 1
        next
      end

      row.delete("space_slug")
      row.delete("space_type")
      row.delete("component_name")
      row.delete("author_type")
      row.delete("author_email")

      proposal = Decidim::Proposals::Proposal.new(row.to_hash)
      proposal.component = component
      proposal.title = eval(row["title"])
      proposal.body = eval(row["body"])

      proposal.coauthorships.build(author: author)

      unless proposal.save
        puts "Could not import Proposal. #{row["id"]} #{row["title"]}"
        puts proposal.errors.full_messages
        could_not_import += 1
        next
      end

      imported += 1
    end

    puts "Imported #{imported} proposals. #{could_not_import} could not be imported"
  end

  def import_scope_types(import_dir)
    path = import_dir.join("scopes_types.csv")

    imported = 0
    could_not_import = 0
    csv = CSV.parse(File.read(path), headers: true)
    csv.each do |row|
      scope_types = Decidim::ScopeType.new(row.to_hash)
      scope_types.name = eval(row["name"])
      scope_types.plural = eval(row["plural"])

      unless scope_types.save
        puts scope_types.errors.full_messages
        could_not_import += 1
        next
      end

      imported += 1
    end
    puts "Imported #{imported} scope types. Could not import #{could_not_import}"
  end

  def import_scopes(import_dir)
    path = import_dir.join("scopes.csv")

    imported = 0
    could_not_import = 0

    csv = CSV.parse(File.read(path), headers: true)
    csv.each do |row|
      scope = Decidim::Scope.new(row.to_hash)
      scope.name = eval(row["name"])

      unless scope.save
        puts scope.errors.full_messages
        could_not_import += 1
        next
      end

      imported += 1
    end

    puts "Imported #{imported} scopes. Could not import #{could_not_import}"
  end

  def import_posts(import_dir)
    path = import_dir.join("posts.csv")

    imported = 0
    csv = CSV.parse(File.read(path), headers: true)
    csv.each do |row|
      title = row["title"]
      body = row["body"]
      component_name = row["component_name"]
      component = Decidim::Component.find_by("name ->> 'ca' = ?", component_name, participatory_space = space)
      author = Decidim::User.find_by(email: row["author_email"])

      row.delete("component_name")
      row.delete("author_email")

      post = Decidim::Blogs::Post.new(row.to_hash)
      post.title = eval(title)
      post.body = eval(body)
      post.component = component
      post.author = author
      post.save!
      imported += 1
    end

    puts "Imported #{imported} blog posts"
  end

  def import_pages(import_dir)
    path = import_dir.join("pages.csv")

    imported = 0
    csv = CSV.parse(File.read(path), headers: true)
    csv.each do |row|
      body = row["body"]
      component_name = row["component_name"]
      component = Decidim::Component.find_by("name ->> 'ca' = ?", component_name)

      row.delete("component_name")
      row.delete("id")

      page = Decidim::Pages::Page.new(row.to_hash)
      page.component = component
      page.body = eval(body)
      page.save!
      imported += 1
    end

    puts "Imported #{imported} posts."
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

  # rubocop: enable Security/Eval
end
