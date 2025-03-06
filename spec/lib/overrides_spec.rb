# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/controllers/decidim/devise/invitations_controller.rb" => "0cbb345ec888627a3a66cce00aba2c25",
      "/app/commands/decidim/create_omniauth_registration.rb" => "5bca48c990c3b82d47119902c0a56ca1",
      "/app/views/decidim/account/show.html.erb" => "a0647f1740d696018f73ec8db8c7587a",
      "/app/views/decidim/devise/sessions/new.html.erb" => "a8fe60cd10c1636822c252d5488a979d",
      "/app/views/decidim/devise/shared/_omniauth_buttons.html.erb" => "de3f80dda35889bc1947d8e6eff3c19a",
      "/app/views/decidim/shared/_login_modal.html.erb" => "a29d4fcebe8c689044e3c15f6144f3d1"
    }
  },
  {
    package: "decidim-admin",
    files: {

      "/app/jobs/decidim/admin/import_participatory_space_private_user_csv_job.rb" => "bd3c600bb488db10a3aeac3941b2cb26",
      "/app/commands/decidim/admin/process_participatory_space_private_user_import_csv.rb" => "4e290b826af84d7cedebb1e6e9526f5b",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "5c354131b4bcd3deb74780595091c502",
      "/app/controllers/decidim/admin/concerns/has_private_users_csv_import.rb" => "45d947412c056a07ef695a115bac1b82",
      "/app/forms/decidim/admin/participatory_space_private_user_form.rb" => "3479f27dcc88f98267374490b446b24c",
      "/app/forms/decidim/admin/participatory_space_private_user_csv_import_form.rb" => "372bff11067a454e0bb4e51b3a93213b",
      # views
      "/app/views/decidim/admin/participatory_space_private_users/_form.html.erb" => "d4a044267fa1f4c261bdc65b3fa198df",
      "/app/views/decidim/admin/participatory_space_private_users/index.html.erb" => "93e081c00098fc9e2cc2c23792ad68e2"
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
