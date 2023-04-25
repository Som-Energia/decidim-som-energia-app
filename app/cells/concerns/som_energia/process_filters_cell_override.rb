# frozen_string_literal: true

# tampers the Participatory Process model to put a default scope in all queries
# if configured previously
module SomEnergia
  module ProcessFiltersCellOverride
    extend ActiveSupport::Concern

    included do
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
end
