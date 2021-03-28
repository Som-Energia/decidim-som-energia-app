# frozen_string_literal: true

# Provides a way for the application to scope participatory_processes depending on their type
# A url scope will be generated for every alternative process type that needs its own
# section, (e.g `/processes` and `/local_groups`)
#
# It also manages redirects for individual participatory_processes to the proper url path if the
# requested participatory_process belongs into another scope:
# (e.g `processes/alternative-participatory_process-slug` > `alternative/alternative-participatory_process-slug`)
class ParticipatoryProcessesScoper
  DEFAULT_NAMESPACE = "processes"

  def self.scoped_participatory_process_slug_prefixes
    return [] unless Rails.application.secrets.scoped_participatory_process_slug_prefixes

    Rails.application.secrets.scoped_participatory_process_slug_prefixes
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)

    return @app.call(env) unless @request.get? # only run middleware for GET requests

    Decidim::ParticipatoryProcess.scope_from_slug_prefixes(nil, nil)

    @organization = env["decidim.current_organization"]
    @scoped_slug_prefixes = scoped_slug_prefixes
    @request_path_parts = request_path_parts(@request)
    @current_participatory_process = find_participatory_process

    return @app.call(env) if out_of_scope?

    alternative_namespace = find_alternative_namespace

    if request_namespace == DEFAULT_NAMESPACE
      # redirect to the alternative namespace if matches the slug prefix
      return redirect(alternative_namespace) unless alternative_namespace.nil?

      # just exclude all types specified as alternative
      Decidim::ParticipatoryProcess.scope_from_slug_prefixes(@scoped_slug_prefixes.values.flatten, :exclude)
    elsif request_namespace && @scoped_slug_prefixes[request_namespace]
      # redirect to default namespace if not matches the slug prefix
      return redirect(DEFAULT_NAMESPACE) if @current_participatory_process && alternative_namespace.nil?

      # include only the ones specified
      Decidim::ParticipatoryProcess.scope_from_slug_prefixes(@scoped_slug_prefixes[request_namespace], :include)
    end

    @app.call(env)
  end

  private

  def scoped_slug_prefixes
    ParticipatoryProcessesScoper
      .scoped_participatory_process_slug_prefixes
      .map { |item| [item[:key], item[:slug_prefixes]] }
      .to_h
  end

  # From "/alternative_assemblies/slug3" to ["", "alternative_assemblies", "slug3"]
  def request_path_parts(request)
    request.path.split("/")
  end

  def request_namespace
    @request_path_parts[1]
  end

  def request_slug
    @request_path_parts[2]
  end

  def find_participatory_process
    return unless request_slug

    Decidim::ParticipatoryProcess
      .unscoped
      .select(:id, :slug)
      .where(organization: @organization)
      .find_by("slug LIKE ?", "#{request_slug}%")
  end

  def out_of_scope?
    @scoped_slug_prefixes.blank? || request_slug && @current_participatory_process.blank?
  end

  def find_alternative_namespace
    return unless (slug = @current_participatory_process&.slug)

    @scoped_slug_prefixes.find do |_key, values|
      values.any? { |prefix| slug.starts_with?(prefix) }
    end&.first
  end

  def redirect(prefix)
    [301, { "Location" => location(prefix), "Content-Type" => "text/html", "Content-Length" => "0" }, []]
  end

  def location(prefix)
    parts = @request_path_parts
    parts[1] = prefix
    parts.join("/")
  end
end
