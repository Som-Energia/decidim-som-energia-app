# frozen_string_literal: true

Decidim::Admin::ParticipatorySpacePrivateUserForm.class_eval do
  attribute :cas_user, Virtus::Attribute::Boolean
end
