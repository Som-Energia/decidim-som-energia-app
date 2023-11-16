# frozen_string_literal: true

# tampers the Participatory Process model to put a default scope in all queries
# if configured previously
module SomEnergia
  module ProcessFiltersCellOverride
    extend ActiveSupport::Concern

    included do
      alias_method :original_filter_link, :filter_link

      # use the alternate url for generating filters if we are scoped
      def filter_link(date_filter, type_filter = nil)
        byebug
        if Decidim::ParticipatoryProcess.scoped_slug_namespace != ParticipatoryProcessesScoper::DEFAULT_NAMESPACE
          return alternative_filter_link(Decidim::ParticipatoryProcess.scoped_slug_namespace, **filter_params(date_filter, type_filter))
        end

        original_filter_link(date_filter, type_filter)
      end

      private

      def alternative_filter_link(key, filter)
        Rails.application.routes.url_helpers.send("#{key}_path", filter)
      end
    end
  end
end