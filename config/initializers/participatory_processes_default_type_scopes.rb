# frozen_string_literal: true

# this middleware will detect by the URL if all calls to ParticipatoryProcess need to skip (or include) certain types
Rails.configuration.middleware.use ParticipatoryProcessesScoper

# tampers the ParticipatoryProcess model to put a default scope in all queries
# if configured previously
Rails.application.config.to_prepare do
  Decidim::ParticipatoryProcess.class_eval do
    class << self
      attr_accessor :scoped_slug_prefixes, :scoped_slug_prefixes_mode, :scoped_slug_namespace

      def scope_from_slug_prefixes(slugs, mode, namespace)
        self.scoped_slug_prefixes = slugs
        self.scoped_slug_prefixes_mode = mode
        self.scoped_slug_namespace = namespace
      end
    end

    def self.default_scope
      return unless scoped_slug_prefixes

      slug_prefixes = scoped_slug_prefixes.map { |slug_prefix| "#{slug_prefix}%" }

      case scoped_slug_prefixes_mode
      when :exclude
        where("slug NOT LIKE ANY (ARRAY[?])", slug_prefixes)
      when :include
        where("slug LIKE ANY (ARRAY[?])", slug_prefixes)
      end
    end
  end

  Decidim::ParticipatoryProcesses::ProcessFiltersCell.class_eval do
    def filter_link(filter)
      current_participatory_processes_path(
        filter: {
          scope_id: get_filter(:scope_id),
          area_id: get_filter(:area_id),
          date: filter
        }
      )
    end

    private

    # use the alternate url for generating filters if we are scoped
    def current_participatory_processes_path(filter)
      if Decidim::ParticipatoryProcess.scoped_slug_namespace != ParticipatoryProcessesScoper::DEFAULT_NAMESPACE
        return alternative_filter_link(Decidim::ParticipatoryProcess.scoped_slug_namespace, filter)
      end

      normal_filter_link(filter)
    end

    def alternative_filter_link(key, filter)
      Rails.application.routes.url_helpers.send("#{key}_path", filter)
    end

    def normal_filter_link(filter)
      Decidim::ParticipatoryProcesses::Engine
        .routes
        .url_helpers
        .participatory_processes_path(filter)
    end
  end
end

Rails.application.config.after_initialize do
  # Creates a new menu next to Processes for every type configured
  ParticipatoryProcessesScoper.scoped_participatory_process_slug_prefixes.each do |item|
    Decidim.menu :menu do |menu|
      menu.item I18n.t(item[:key], scope: "decidim.participatory_processes.scoped_participatory_process_slug_prefixes"),
                Rails.application.routes.url_helpers.send("#{item[:key]}_path"),
                position: item[:position_in_menu],
                if: (
                  Decidim::ParticipatoryProcess
                  .unscoped
                  .where(organization: current_organization)
                  .where("slug LIKE ANY (ARRAY[?])", item[:slug_prefixes].map { |slug_prefix| "#{slug_prefix}%" })
                  .published
                  .any?
                ),
                active: :inclusive
    end
  end
end
