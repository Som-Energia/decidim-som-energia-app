# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Proposals
    # Common logic to ordering resources
    module Orderable
      extend ActiveSupport::Concern

      included do
        include Decidim::Orderable

        private

        # Override
        # Gets how the proposals should be ordered based on the choice
        # made by the user.
        def order
          @order ||= detect_order(session[:order]) || default_order
        end

        # Available orders based on enabled settings
        def available_orders
          @available_orders ||= begin
            available_orders = %w(random recent)
            available_orders.prepend "alphabetic" if alternative_process?
            available_orders << "most_voted" if most_voted_order_available?
            available_orders << "most_endorsed" if current_settings.endorsements_enabled?
            available_orders << "most_commented" if component_settings.comments_enabled?
            available_orders << "most_followed" << "with_more_authors"
            available_orders
          end
        end

        def alternative_process?
          @alternative_process ||= begin
            return unless current_participatory_space.manifest.name == :participatory_processes

            scoped_slug_prefixes = ParticipatoryProcessesScoper.scoped_participatory_process_slug_prefixes.map { |item| item[:slug_prefixes] }.flatten
            scoped_slug_prefixes.detect { |prefix| current_participatory_space.slug.starts_with?(prefix) }
          end
        end

        def default_order
          if alternative_process?
            "alphabetic"
          elsif order_by_votes?
            detect_order("most_voted")
          else
            "random"
          end
        end

        def most_voted_order_available?
          current_settings.votes_enabled? && !current_settings.votes_hidden?
        end

        def order_by_votes?
          most_voted_order_available? && current_settings.votes_blocked?
        end

        def reorder(proposals)
          case order
          when "alphabetic"
            proposals.order("decidim_proposals_proposals.title->>'#{locale}' ASC, decidim_proposals_proposals.title->>'es' ASC")
          when "most_commented"
            proposals.left_joins(:comments).group(:id).order(Arel.sql("COUNT(decidim_comments_comments.id) DESC"))
          when "most_endorsed"
            proposals.order(endorsements_count: :desc)
          when "most_followed"
            proposals.left_joins(:follows).group(:id).order(Arel.sql("COUNT(decidim_follows.id) DESC"))
          when "most_voted"
            proposals.order(proposal_votes_count: :desc)
          when "random"
            proposals.order_randomly(random_seed)
          when "recent"
            proposals.order(published_at: :desc)
          when "with_more_authors"
            proposals.order(coauthorships_count: :desc)
          end
        end
      end
    end
  end
end
