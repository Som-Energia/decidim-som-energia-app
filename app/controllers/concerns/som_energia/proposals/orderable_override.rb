# frozen_string_literal: true

# TODO: check awesome compatiblity
module SomEnergia
  module Proposals
    module OrderableOverride
      extend ActiveSupport::Concern

      included do
        alias_method :original_awesome_additional_sortings, :awesome_additional_sortings

        private

        def alternative_process?
          @alternative_process ||= if current_participatory_space.manifest.name == :participatory_processes
                                     scoped_slug_prefixes = ParticipatoryProcessesScoper.scoped_participatory_process_slug_prefixes.map { |item| item[:slug_prefixes] }.flatten
                                     scoped_slug_prefixes.detect { |prefix| current_participatory_space.slug.starts_with?(prefix) }
                                   end
        end

        def order_by_default
          if alternative_process? && original_awesome_additional_sortings.include?("az")
            "az"
          elsif order_by_votes?
            "most_voted"
          else
            "random"
          end
        end
      end
    end
  end
end
