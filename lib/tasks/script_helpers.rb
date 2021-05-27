# frozen_string_literal: true

require 'csv'

module ScriptHelpers
  HELP_TEXT = "
You need to specifiy an organization id and a CSV to process:
ie: rails \"som:import_users[ORG_ID,../some-file.csv]\"

Not found proposals will be skipped"

  CSV_TEXT = "
CSV format must follow this specification:

1st line is treated as header and must containt the fields: id, nom, email, soci, dni
Rest of the lines must containt values for the corresponding headers
"

  def process_csv(args)
    raise ArgumentError if args.organization_id.blank?
    raise ArgumentError if args.csv.blank?

    organization = Decidim::Organization.find_by(id: args.organization_id)
    raise ArgumentError, "#{args.organization_id} not found" unless organization

    puts "Importing users to organization [#{organization.host}], ok? [y/n]"
    ok = STDIN.gets.chomp
    return unless ok == "y"

    table = CSV.parse(File.read(args.csv), headers: true)

    table.each_with_index do |line, index|
      print "##{index} (#{100 * (index + 1) / table.count}%): "
      begin
        yield(organization, line)
      rescue UnprocessableError => e
        show_error(e.message)
      rescue ActiveRecord::RecordInvalid => e
        show_error(e.message)            
      rescue AlreadyProcessedError => e
        show_warning(e.message)
      end
    end
  rescue ArgumentError => e
    puts
    show_error(e.message)
    show_help
  rescue CSV::MalformedCSVError => e
    puts
    show_error(e.message)
    show_csv_format
  end

  def show_error(msg)
    puts "\e[31mERROR:\e[0m #{msg}"
  end

  def show_warning(msg)
    puts "\e[33mWARN:\e[0m #{msg}"
  end

  def show_success(msg)
    puts " \e[32m#{msg}\e[0m"
  end

  def normalize_user(line)
    values = { extra_attributes: {} }
    line.each do |key, value|
      case key
      when /^email$/i
        values[:email] = value
      when /^nom|name|nombre$/i
        values[:name] = value
      when /^dni$/i
        values[:username] = value
        values[:extra_attributes][:username] = value 
      when /^soci|socia|socio$/i
        values[:extra_attributes][:soci] = value 
      end
    end
    raise_if_field_not_found(:email, values)
    raise_if_field_not_found(:username, values)
    raise_if_field_not_found(:soci, values[:extra_attributes])
    values
  end

  def emails_from(text)
    text.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
  end

  def raise_if_field_not_found(field, values)
    raise UnprocessableError, "#{field.upcase} field not found for [#{values}]" unless values[field].present?
  end

  def show_help
    puts HELP_TEXT
  end

  def show_csv_format
    puts CSV_TEXT
  end

  class UnprocessableError < StandardError
  end

  class AlreadyProcessedError < StandardError
  end
end
