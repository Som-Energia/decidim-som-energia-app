# frozen_string_literal: true

namespace :active_storage do
  desc "Migrate legacy Rails 6 ActiveStorage URLs to Rails 7 inside localized JSONB fields"
  task migrate_jsonb_urls: :environment do
    include Rails.application.routes.url_helpers

    TARGETS = {
      "Decidim::ParticipatoryProcess" => [:short_description, :description],
      "Decidim::Assembly" => [:short_description, :description],
      "Decidim::Proposals::Proposal" => [:body],
      "Decidim::Meetings::Meeting" => [:body]
    }.freeze

    def find_blob_by_filename(filename, record)
      clean_filename = CGI.unescape(filename)

      matching_blobs = ActiveStorage::Blob.where(filename: clean_filename)

      case matching_blobs.count
      when 0
        puts "    [Warning] No blob found for filename: #{clean_filename}"
        return nil
      when 1
        return matching_blobs.first
      end

      # Multiple blobs share the same filename.
      # Try to find the one attached to the current record.
      attachment = ActiveStorage::Attachment.find_by(
        record_type: record.class.name,
        record_id: record.id,
        blob_id: matching_blobs.select(:id)
      )

      return attachment.blob if attachment

      puts "    [Warning] Multiple blobs found for '#{clean_filename}', using first match."
      matching_blobs.first
    end

    # Capture:
    # 1. Entire legacy URL
    # 2. Signed token
    # 3. Filename
    url_regex = %r{
      (/rails/active_storage/blobs/redirect/([^/]+)/([^"\s>]+))
    }x

    TARGETS.each do |model_name, columns|
      model = model_name.safe_constantize
      next unless model

      puts "=== Processing #{model_name} ==="

      model.find_each do |record|
        changes_made = false

        columns.each do |column|
          json_data = record.read_attribute(column)
          next unless json_data.is_a?(Hash)

          json_data.each do |locale, html|
            next unless html.is_a?(String)

            updated_html = html.dup

            updated_html.scan(url_regex).uniq.each do |old_path, _old_token, filename|
              blob = find_blob_by_filename(filename, record)

              unless blob
                puts "  [Warning] Record ##{record.id} (#{locale}): Could not locate blob for #{filename}"
                next
              end

              new_path = rails_blob_path(blob, only_path: true)

              updated_html.gsub!(old_path, new_path)

              puts "  [Success] Record ##{record.id} (#{locale}): #{filename} → Blob ##{blob.id}"
              changes_made = true
            end

            json_data[locale] = updated_html
          end

          record.write_attribute(column, json_data)
        end

        if changes_made
          record.save!(validate: false)
          puts "  [Saved] Record ##{record.id}"
        end
      end
    end

    puts "=== Migration Finished Successfully ==="
  end
end
