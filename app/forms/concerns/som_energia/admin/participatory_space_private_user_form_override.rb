# frozen_string_literal: true

module SomEnergia
  module Admin
    module ParticipatorySpacePrivateUserFormOverride
      extend ActiveSupport::Concern

      included do
        attribute :cas_user, Virtus::Attribute::Boolean
      end
    end
  end
end
