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
      "/app/helpers/decidim/icon_helper.rb" => "952fac462893c32fbd367cea72be38cb",
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
      "/app/helpers/decidim/consultations/consultations_helper.rb" => "bb921ed6da446b9544b81c9f9f9a7574",
      "/app/forms/decidim/consultations/admin/question_configuration_form.rb" => "fd988f15b1242e582cc7d0cc8d3d1d2e",
      "/app/commands/decidim/consultations/admin/update_question_configuration.rb" => "34beed38a9eb629498dca31b59598302",
      "/app/views/decidim/consultations/question_multiple_votes/show.html.erb" => "d647ab9bcefd55d9c7b864d1e9c6aead",
      "/app/forms/decidim/consultations/admin/response_form.rb" => "e567a9a49bc702ba630ef7b1cf5f2488",
      "/app/views/decidim/consultations/admin/responses/_form.html.erb" => "6846d66395457acdd7d6ec839a49b0ec",
      "/app/commands/decidim/consultations/admin/create_response.rb" => "340f0e81855a53a6a03deeea6f07d653",
      "/app/commands/decidim/consultations/admin/update_response.rb" => "5e09376f773c0ac062c77767c872cd41",
      "/app/views/decidim/consultations/question_multiple_votes/_form.html.erb" => "af610283ce7ee20f5ef786228a263d4a",
      # modified
      "/app/views/decidim/consultations/admin/question_configuration/_form.html.erb" => "0655db0b199a7cb49389f055210a9cdb",
      "/app/views/decidim/consultations/admin/consultations/results.html.erb" => "1a2f7afd79b20b1fcf66bdece660e8ae",
      "/app/views/decidim/consultations/question_multiple_votes/_voting_rules.html.erb" => "5290000e36d1508d588218ad3bb8c808",
      "/app/views/decidim/consultations/questions/show.html.erb" => "1608782bab215fb95920fc3e824a8a5a",
      "/app/views/decidim/consultations/questions/_results.html.erb" => "2d8196efbf23e2ad7b8c32713c28b240"
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
  },
  {
    package: "decidim-action_delegator",
    files: {
      "/app/views/decidim/consultations/questions/_vote_modal.html.erb" => "d526922aee8bf27838e53ccc8aeeaa0c"
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
