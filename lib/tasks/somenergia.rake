# frozen_string_literal: true

require_relative "script_helpers"

namespace :som do
  include ScriptHelpers

  desc "Test email server"
  task :mail_test, [:email] => :environment do |_task, args|
    raise ArgumentError if args.email.blank?

    puts "Sending a test email to #{args.email}"

    if ENV["SMTP_SETTINGS"].present?
      settings_string = ENV["SMTP_SETTINGS"].gsub(/(\w+)\s*:/, '"\1":').gsub("\\", "").gsub("'", "")
      settings = JSON.parse(settings_string).to_h
      ActionMailer::Base.smtp_settings = settings
      puts "Using custom settings!"
    end
    puts "Using configuration:"
    puts ActionMailer::Base.smtp_settings

    mail = ActionMailer::Base.mail(to: args.email,
                                   from: Decidim.mailer_sender,
                                   subject: "A test mail from #{Decidim.application_name}",
                                   body: "Sent by #{ENV.fetch("LOGNAME", nil)} in #{Dir.home} at #{Date.current}")
    mail.deliver_now
  rescue ArgumentError
    puts mail_usage
  end

  def mail_usage
    "Usage:
bin/rails 'som:mail_test[email@example.org]'

Override default configuration with the ENV var SMTP_SETTINGS:

export SMTP_SETTINGS='{address: \"stmp.example.org\", port: 25, enable_starttls_auto: true}'
"
  end

  desc "import users from a CSV"
  task :import_users, [:organization_id, :csv] => :environment do |_task, args|
    process_csv(args) do |organization, line|
      user = normalize_user(line)
      raise AlreadyProcessedError, "user #{user[:email]} already existing. SKIPPING" if Decidim::User.find_by(email: user[:email], username: user[:username], organization:)

      user = Decidim::User.new(user)
      user.organization = organization
      user.nickname = Decidim::UserBaseEntity.nicknamize(user.name, organization:)
      user.save!(validate: false)
      puts "Created user #{user.email} #{user.extended_data}"
    end
  end
end
