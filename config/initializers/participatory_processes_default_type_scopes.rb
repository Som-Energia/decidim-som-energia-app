# frozen_string_literal: true

# this middleware will detect by the URL if all calls to ParticipatoryProcess need to skip (or include) certain types
Rails.configuration.middleware.use ParticipatoryProcessesScoper

# tampers the ParticipatoryProcess model to put a default scope in all queries
# if configured previously
Rails.application.config.to_prepare do
  Decidim::ParticipatoryProcess.class_eval do
    class << self
      attr_accessor :scoped_slug_prefixes, :scoped_slug_prefixes_mode

      def scope_from_slug_prefixes(slugs, mode)
        self.scoped_slug_prefixes = slugs
        self.scoped_slug_prefixes_mode = mode
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
