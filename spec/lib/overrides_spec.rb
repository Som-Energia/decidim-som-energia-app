# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/controllers/decidim/devise/invitations_controller.rb" => "3f7224ebdf7eb3ad2d550344021c795f",
      "/app/controllers/decidim/devise/sessions_controller.rb" => "e60834d5892b0539b967328888b25829",
      "/app/controllers/decidim/devise/registrations_controller.rb" => "d5f7e3d61b62c3ce2704ecd48f2a080c",
      "/app/commands/decidim/create_omniauth_registration.rb" => "b31a2a77e41b56cf8d3ae500da7c2d13",
      "/app/views/decidim/account/show.html.erb" => "f13218e2358a2d611996c2a197c0de25",
      "/app/views/decidim/devise/sessions/new.html.erb" => "a8fe60cd10c1636822c252d5488a979d",
      "/app/views/decidim/devise/shared/_omniauth_buttons.html.erb" => "de3f80dda35889bc1947d8e6eff3c19a",
      "/app/views/decidim/shared/_login_modal.html.erb" => "0d615603bb45f7b209032578dda9fc72"
    }
  },
  {
    package: "decidim-admin",
    files: {

      "/app/jobs/decidim/admin/import_participatory_space_private_user_csv_job.rb" => "5d3f6702aac75dd54ca19299e57a16c0",
      "/app/commands/decidim/admin/process_participatory_space_private_user_import_csv.rb" => "c28a9a444df8adf4a87359e3e16ee5e5",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "81b2a47da331d70d8f530777b9b11dc2",
      "/app/controllers/decidim/admin/concerns/has_private_users_csv_import.rb" => "a33ecdf482bbca6b34552440abcf0811",
      "/app/forms/decidim/admin/participatory_space_private_user_form.rb" => "3479f27dcc88f98267374490b446b24c",
      "/app/forms/decidim/admin/participatory_space_private_user_csv_import_form.rb" => "372bff11067a454e0bb4e51b3a93213b",
      # views
      "/app/views/decidim/admin/participatory_space_private_users/_form.html.erb" => "d4a044267fa1f4c261bdc65b3fa198df",
      "/app/views/decidim/admin/participatory_space_private_users/index.html.erb" => "64b8ee5d19d4f8924da2d739ca693b25"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
