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
      "/app/controllers/decidim/devise/sessions_controller.rb" => "7cecc389de97bf63f17da505d6c05774",
      "/app/controllers/decidim/devise/registrations_controller.rb" => "329ff82cc840b677a706048b6360c04a",
      "/app/commands/decidim/create_omniauth_registration.rb" => "ead367ec34a1047df80d7003c2751eee",
      "/app/views/decidim/account/show.html.erb" => "f13218e2358a2d611996c2a197c0de25",
      "/app/views/decidim/devise/sessions/new.html.erb" => "da0d18178c8dcead2774956e989527c5",
      "/app/views/decidim/devise/shared/_omniauth_buttons.html.erb" => "688a13e36af349a91e37b04c6caaa3a9",
      "/app/views/decidim/shared/_login_modal.html.erb" => "98bd2832be207d7abcd48d2a0ba40bd0",
      "/app/cells/decidim/authorization_modal_cell.rb" => "c7c1d02f217c3885e38de513839bf92e",
      "/app/cells/decidim/activity_cell.rb" => "1396f2caf558d833ccc6a21953154458"
    }
  },
  {
    package: "decidim-admin",
    files: {

      "/app/jobs/decidim/admin/import_participatory_space_private_user_csv_job.rb" => "5d3f6702aac75dd54ca19299e57a16c0",
      "/app/commands/decidim/admin/process_participatory_space_private_user_import_csv.rb" => "c28a9a444df8adf4a87359e3e16ee5e5",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "1524537dc2f1518693d79e2daf04be1b",
      "/app/controllers/decidim/admin/concerns/has_private_users_csv_import.rb" => "a33ecdf482bbca6b34552440abcf0811",
      "/app/forms/decidim/admin/participatory_space_private_user_form.rb" => "bf7286d9f982673b07fce49812616fd3",
      "/app/forms/decidim/admin/participatory_space_private_user_csv_import_form.rb" => "372bff11067a454e0bb4e51b3a93213b",
      # views
      "/app/views/decidim/admin/participatory_space_private_users/_form.html.erb" => "d3af92bee680cf2cceb946e24855f2e9",
      "/app/views/decidim/admin/participatory_space_private_users/index.html.erb" => "48a25a1a43950b29b03e5861a3d26fb6"
    }
  },
  {
    package: "decidim-verifications",
    files: {
      "/app/helpers/decidim/verifications/application_helper.rb" => "9f40fba8f2f7f16d588b8bcad4300376"
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
