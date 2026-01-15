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
      "/app/controllers/decidim/devise/registrations_controller.rb" => "3b9d431d19e456aeab3eb861b6189bf4",
      "/app/commands/decidim/create_omniauth_registration.rb" => "31ce55b44db4e53151f11524d26d8832",
      "/app/views/decidim/account/show.html.erb" => "1c230c5c6bc02e0bb22e1ea92b0da96c",
      "/app/views/decidim/devise/sessions/new.html.erb" => "da0d18178c8dcead2774956e989527c5",
      "/app/views/decidim/devise/shared/_omniauth_buttons.html.erb" => "688a13e36af349a91e37b04c6caaa3a9",
      "/app/views/decidim/shared/_login_modal.html.erb" => "98bd2832be207d7abcd48d2a0ba40bd0",
      "/app/cells/decidim/authorization_modal_cell.rb" => "c7c1d02f217c3885e38de513839bf92e",
      "/app/cells/decidim/activity_cell.rb" => "e2345598669f6312f17ee964950a83bc"
    }
  },
  {
    package: "decidim-admin",
    files: {

      "/app/jobs/decidim/admin/import_participatory_space_private_user_csv_job.rb" => "5d3f6702aac75dd54ca19299e57a16c0",
      "/app/commands/decidim/admin/process_participatory_space_private_user_import_csv.rb" => "c28a9a444df8adf4a87359e3e16ee5e5",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "1524537dc2f1518693d79e2daf04be1b",
      "/app/controllers/decidim/admin/concerns/has_private_users_csv_import.rb" => "1dacbcb0cc21aa5b753e5e83fb9c92d3",
      "/app/forms/decidim/admin/participatory_space_private_user_form.rb" => "bf7286d9f982673b07fce49812616fd3",
      "/app/forms/decidim/admin/participatory_space_private_user_csv_import_form.rb" => "372bff11067a454e0bb4e51b3a93213b",
      # views
      "/app/views/decidim/admin/participatory_space_private_users/_form.html.erb" => "d3af92bee680cf2cceb946e24855f2e9",
      "/app/views/decidim/admin/participatory_space_private_users/index.html.erb" => "26fd9000f99fa0a3af1c6ffdf359e076"
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
