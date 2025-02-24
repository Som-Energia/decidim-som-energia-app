# frozen_string_literal: true

# require "rails_helper"

# describe "Participatory_space_private_users" do
#   let(:organization) { create(:organization) }
#   let(:user) { create(:user, :admin, :confirmed, organization:) }
#   let(:assembly) { create(:assembly, organization:) }
#   let(:setup) { nil }
#   let(:assembly_private_user) do
#     user = create(:user, organization:)
#     create(:assembly_private_user, user:, privatable_to: assembly)
#   end

#   before do
#     setup
#     switch_to_host(organization.host)
#     login_as user, scope: :user
#     visit decidim_admin_assemblies.edit_assembly_path(assembly)
#     find("a[href*='participatory_space_private_users']").click
#   end

#   describe "table" do
#     let(:setup) do
#       assembly_private_user
#     end

#     it "shows CAS User column" do
#       expect(page).to have_css("th", text: "CAS User")
#       within page.find(:xpath, "(//tbody/tr/td)[2]") do
#         expect(page).to have_content("No")
#       end
#     end

#     context "when user is CAS user" do
#       let(:setup) do
#         assembly_private_user
#         assembly_private_user.update(cas_user: true)
#       end

#       it "shows CAS User column" do
#         expect(page).to have_css("th", text: "CAS User")
#         within page.find(:xpath, "(//tbody/tr/td)[2]") do
#           expect(page).to have_content("Yes")
#         end
#       end
#     end
#   end

#   describe "invites" do
#     shared_examples "invitation email" do
#       let(:last_email_body) { ActionMailer::Base.deliveries.last.encoded }
#       let(:expected_invitation_link) do
#         decidim.accept_user_invitation_url(invitation_token:, host: organization.host)
#       end

#       it "has correct invitation link" do
#         expect(last_email_body).to have_content(expected_invitation_link)
#       end
#     end

#     shared_examples "invitation link" do
#       before do
#         logout :user
#         visit accept_invitation_path
#       end

#       it "has expected path" do
#         expect(page).to have_current_path(expected_path)
#       end
#     end

#     class Decidim::User
#       private

#
#       def generate_invitation_token
#         @raw_invitation_token = "raw_invitation_token"
#         self.invitation_token = Devise.token_generator.digest(self, :invitation_token, @raw_invitation_token)
#       end
#       # rubocop:enable RSpec/InstanceVariable
#     end

#     before do
#       find("a[href*='participatory_space_private_users/new']").click
#       fill_in :participatory_space_private_user_name, with: "Whatever"
#       fill_in :participatory_space_private_user_email, with: "what@ever.com"
#       fill_cas_user_checkbox
#       perform_enqueued_jobs { find("*[type=submit]").click }
#     end

#     let(:invitation_token) do
#       user.send(:generate_invitation_token)
#       user.instance_variable_get(:@raw_invitation_token)
#     end
#     let(:accept_invitation_path) { decidim.accept_user_invitation_path(invitation_token:) }

#     context "when inviting CAS user" do
#       let(:fill_cas_user_checkbox) do
#         check :participatory_space_private_user_cas_user
#       end

#       it_behaves_like "invitation email"

#       it_behaves_like "invitation link" do
#         # Regexp to match String starting with "/login?service="
#         # followed by anything (escaped host and port)
#         # and ending with "%2Fusers%2Fcas%2Fservice&locale=en"
#         let(:expected_path_with_cas_server_running) { %r{\A/login\?service=.*%2Fusers%2Fcas%2Fservice&locale=en\z} }
#         let(:expected_path_without_cas_server_running) { "users/cas/sign_in" }
#         let(:expected_path) do
#           Regexp.union(
#             expected_path_with_cas_server_running,
#             expected_path_without_cas_server_running
#           )
#         end
#       end
#     end

#     context "when inviting NON CAS user" do
#       let(:fill_cas_user_checkbox) do
#         uncheck :participatory_space_private_user_cas_user
#       end

#       it_behaves_like "invitation email"

#       it_behaves_like "invitation link" do
#         let(:expected_path) { accept_invitation_path }
#       end
#     end
#   end
# end
