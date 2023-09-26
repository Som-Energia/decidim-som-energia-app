# frozen_string_literal: true

# Provides a way for the application to scope participatory_processes depending on their type
# A url scope will be generated for every alternative process type that needs its own
# section, (e.g `/processes` and `/general_assemblies`)
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

    reset_participatory_process_model_default_scope

    @organization = env["decidim.current_organization"]
    @request_path_parts = request_path_parts
    @current_participatory_process = find_participatory_process

    return @app.call(env) if out_of_scope?

    @alternative_namespace = find_alternative_namespace

    if requesting_default_processes?
      return redirect(@alternative_namespace) if alternative_current_participatory_process?

      exclude_alternative_participatory_processes_from_default_scope
    elsif requesting_alternative_processes?
      return redirect(DEFAULT_NAMESPACE) if normal_current_participatory_process?

      exclude_normal_participatory_processes_from_default_scope
    end

    @app.call(env)
  end

  private

  def reset_participatory_process_model_default_scope
    Decidim::ParticipatoryProcess.scope_from_slug_prefixes(nil, nil, nil)
  end

  def scoped_slug_prefixes
    @scoped_slug_prefixes ||=
      ParticipatoryProcessesScoper
      .scoped_participatory_process_slug_prefixes
      .map { |item| [item[:key], item[:slug_prefixes]] }
      .to_h
  end

  # From "/alternative_assemblies/slug3" to ["", "alternative_assemblies", "slug3"]
  def request_path_parts
    @request.path.split("/")
  end

  def request_namespace
    @request_path_parts[1]
  end

  def request_slug
    @request_path_parts[2]
  end

  def find_participatory_process
    return unless @organization && request_slug

    Decidim::ParticipatoryProcess
      .unscoped
      .select(:id, :slug)
      .where(organization: @organization)
      .find_by("slug LIKE ?", "#{request_slug}%")
  end

  def out_of_scope?
    scoped_slug_prefixes.blank? || (request_slug && @current_participatory_process.blank?)
  end

  def find_alternative_namespace
    return unless request_slug

    scoped_slug_prefixes.find do |_key, values|
      values.any? { |prefix| request_slug.starts_with?(prefix) }
    end.to_a.first
  end

  def requesting_default_processes?
    request_namespace == DEFAULT_NAMESPACE
  end

  def requesting_alternative_processes?
    request_namespace && scoped_slug_prefixes[request_namespace]
  end

  def alternative_current_participatory_process?
    @current_participatory_process && @alternative_namespace
  end

  def normal_current_participatory_process?
    @current_participatory_process && @alternative_namespace.nil?
  end

  def exclude_alternative_participatory_processes_from_default_scope
    Decidim::ParticipatoryProcess.scope_from_slug_prefixes(scoped_slug_prefixes.values.flatten, :exclude, request_namespace)
  end

  def exclude_normal_participatory_processes_from_default_scope
    Decidim::ParticipatoryProcess.scope_from_slug_prefixes(scoped_slug_prefixes[request_namespace], :include, request_namespace)
  end

  def redirect(namespace)
    [301, { "Location" => location(namespace), "Content-Type" => "text/html", "Content-Length" => "0" }, []]
  end

  def location(namespace)
    parts = request_path_parts
    parts[1] = namespace
    parts.join("/")
  end
end
