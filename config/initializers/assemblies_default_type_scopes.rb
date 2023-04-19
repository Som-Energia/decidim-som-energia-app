# frozen_string_literal: true

# tampers the Assembly model to put a default scope in all queries
# if configured previously
Rails.application.config.to_prepare do
  Decidim::Assembly.class_eval do
    class << self
      attr_accessor :scope_types, :scope_types_mode

      def scope_to_types(types, mode)
        self.scope_types = types
        self.scope_types_mode = mode
      end
    end

    def self.default_scope
      return unless scope_types

      case scope_types_mode
      when :exclude
        where("decidim_assemblies_type_id IS NULL OR decidim_assemblies_type_id NOT IN (?)", scope_types)
      when :include
        where(decidim_assemblies_type_id: scope_types)
      end
    end
  end
end

Rails.application.config.after_initialize do
  # Creates a new menu next to Assemblies for every type configured
  AssembliesScoper.alternative_assembly_types.each do |item|
    Decidim.menu :menu do |menu|
      menu.item I18n.t(item[:key], scope: "decidim.assemblies.alternative_assembly_types"),
                Rails.application.routes.url_helpers.send("#{item[:key]}_path"),
                position: item[:position_in_menu],
                if: Decidim::Assembly.unscoped.where(organization: current_organization, assembly_type: item[:assembly_type_ids]).published.any?,
                active: :inclusive
    end
  end
end
