# frozen_string_literal: true

# require "rails_helper"

# module Decidim::Assemblies::Admin
#   describe ParticipatorySpacePrivateUsersCsvImportsController do
#     routes { Decidim::Assemblies::AdminEngine.routes }

#     let(:organization) { create(:organization) }
#     let(:user) { create(:user, :admin, :confirmed, organization:) }
#     let(:assembly) { create(:assembly, organization:) }
#     let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/import_participatory_space_users_invalid_email.csv"), "text/csv") }

#     let(:params) do
#       {
#         assembly_slug: assembly.slug,
#         file:
#       }
#     end

#     before do
#       request.env["decidim.current_organization"] = organization
#       request.env["decidim.current_assembly"] = assembly
#       sign_in user, scope: :user
#     end

#     describe "GET create" do
#       it "renders the form" do
#         post(:create, params:)

#         expect(flash[:alert]).to eq("1 emails no s'han pogut processar: [\"my_userexample.org\"]")
#         expect(response).to have_http_status(:redirect)
#       end

#       context "when invalid file" do
#         let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/import_participatory_space_users_no_email.csv"), "text/csv") }

#         it "renders the form" do
#           post(:create, params:)

#           expect(flash[:alert]).to eq("There was a problem reading the CSV file.: [\"La primera columna ha de contenir emails vàlids!\"]")
#           expect(response).to have_http_status(:ok)
#         end
#       end
#     end
#   end
# end
