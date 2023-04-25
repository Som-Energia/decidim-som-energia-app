# frozen_string_literal: true

# tampers the Participatory Process model to put a default scope in all queries
# if configured previously
module SomEnergia
  module ParticipatoryProcessOverride
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :scoped_slug_prefixes, :scoped_slug_prefixes_mode, :scoped_slug_namespace

      def scope_from_slug_prefixes(slugs, mode, namespace)
        self.scoped_slug_prefixes = slugs
        self.scoped_slug_prefixes_mode = mode
        self.scoped_slug_namespace = namespace
      end

      def default_scope
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
end
