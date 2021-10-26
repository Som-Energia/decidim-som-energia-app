# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/controllers/decidim/devise/invitations_controller.rb" => "faa5403c358f686a87eea2d9f4eaf1d4",
      "/app/views/layouts/decidim/mailer.html.erb" => "5bbe335c1dfd02f8448af287328a49dc"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/_filter_by_type.html.erb" => "76988d76b84d96079e6d9e1b252a3fda"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/controllers/concerns/decidim/proposals/orderable.rb" => "066b6b777567297eefd80020468d4610",
      "/app/controllers/decidim/proposals/proposals_controller.rb" => "c867dc602f0b73a2299d5e90677a54f4"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      "/app/views/decidim/meetings/registration_mailer/confirmation.html.erb" => "949b197162b9f57810a4d80715f3626d",
      # Meetings natural order, to remove when available as a feature of decidim
      "/app/controllers/decidim/meetings/meetings_controller.rb" => "9b5f2673ac38699c86c89fbd0d6e326f"
    }
  },
  {
    package: "decidim-consultations",
    files: {
      # not directly manipulated but worth taking a look if anythign changes
      "/app/controllers/decidim/consultations/consultations_controller.rb" => "3d75aa7d00721dc3d91aca131d348362",
      "/app/controllers/decidim/consultations/questions_controller.rb" => "1b7ec4c7265caccd47f9dc9be08498a9",
      "/app/views/decidim/consultations/consultations/_question.html.erb" => "364d7f8370cdbe7ae70c545fff2e21fa",
      "/app/helpers/decidim/consultations/consultations_helper.rb" => "bb921ed6da446b9544b81c9f9f9a7574"
    }
  },
  {
    package: "decidim-initiatives",
    files: {
      "/app/controllers/decidim/initiatives/initiatives_controller.rb" => "a2c79d47e459d5bdd2c011491f2c2b1b",
      "/app/mailers/decidim/initiatives/initiatives_mailer.rb" => "435a4110f6bc5c8f37eebc36fae4d444",
      "/app/views/decidim/initiatives/initiatives_mailer/notify_creation.html.erb" => "5ce00a2d62b52b098bb8464e5bf5e16a",
      "/app/views/decidim/initiatives/initiatives_mailer/notify_state_change.html.erb" => "6472242f33e29183e08c2caefd5d6067"
    }
  },
  {
    package: "decidim-admin",
    files: {

      "/app/jobs/decidim/admin/import_participatory_space_private_user_csv_job.rb" => "c32cc9663ff3e1b51ce38546a6aa4678",
      "/app/commands/decidim/admin/process_participatory_space_private_user_import_csv.rb" => "06cafc1c6bd098bf30c8fba9f3a12a4d",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "b380a8e10e9f54aff7e2669f128b261a",
      "/app/controllers/decidim/admin/concerns/has_private_users_csv_import.rb" => "5e6f74f827fc3d0d485cfeec7ecb43e3",
      "/app/forms/decidim/admin/participatory_space_private_user_form.rb" => "3479f27dcc88f98267374490b446b24c",
      "/app/forms/decidim/admin/participatory_space_private_user_csv_import_form.rb" => "f93e15ec32dbb59a0989b27641356075",
      # views
      "/app/views/decidim/admin/participatory_space_private_users/_form.html.erb" => "be3e6ce2ae14caee518d0def6091c9e0",
      "/app/views/decidim/admin/participatory_space_private_users/index.html.erb" => "a2658de61e06a6536778e8193f3cc8b8"
    }
  }
]

describe "Overriden files", type: :view do
  # rubocop:disable Rails/DynamicFindBy
  checksums.each do |item|
    spec = ::Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end
  # rubocop:enable Rails/DynamicFindBy

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
