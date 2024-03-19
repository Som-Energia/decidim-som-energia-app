# frozen_string_literal: true

# tampers the Assembly model to put a default scope in all queries
# if configured previously
module SomEnergia
  module AssemblyOverride
    extend ActiveSupport::Concern

    included do
      default_scope do
        if scope_types
          case scope_types_mode
          when :exclude
            where("decidim_assemblies_type_id IS NULL OR decidim_assemblies_type_id NOT IN (?)", scope_types)
          when :include
            where(decidim_assemblies_type_id: scope_types)
          end
        end
      end
    end

    class_methods do
      attr_accessor :scope_types, :scope_types_mode

      def scope_to_types(types, mode)
        self.scope_types = types
        self.scope_types_mode = mode
      end
    end
  end
end
