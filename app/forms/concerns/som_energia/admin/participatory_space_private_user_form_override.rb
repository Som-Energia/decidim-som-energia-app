# frozen_string_literal: true

module SomEnergia
  module Admin
    module ParticipatorySpacePrivateUserFormOverride
      extend ActiveSupport::Concern

      included do
        include Decidim::AttributeObject

        attribute :cas_user, :boolean
      end
    end
  end
end
