# # frozen_string_literal: true

# require "rails_helper"

# describe "Assemblies" do
#   let(:organization) { create(:organization) }
#   let!(:local_groups) { create(:assemblies_type, id: 5) }
#   let!(:type2) { create(:assemblies_type, id: 2) }
#   let!(:alternative_assembly) do
#     create(
#       :assembly,
#       slug: "slug1",
#       scope: first_scope,
#       area: first_area,
#       assembly_type: local_groups,
#       organization:
#     )
#   end
#   let!(:assembly) do
#     create(
#       :assembly,
#       slug: "slug2",
#       scope: second_scope,
#       area: second_area,
#       assembly_type: nil,
#       organization:
#     )
#   end
#   let!(:assembly2) do
#     create(
#       :assembly,
#       slug: "slug3",
#       scope: second_scope,
#       area: second_area,
#       assembly_type: type2,
#       organization:
#     )
#   end
#   let!(:first_scope) { create(:scope, organization:) }
#   let!(:second_scope) { create(:scope, organization:) }
#   let!(:first_area) { create(:area, organization:) }
#   let!(:second_area) { create(:area, organization:) }
#   let!(:member) { create(:assembly_member, assembly: alternative_assembly) }

#   before do
#     switch_to_host(organization.host)
#   end

#   context "when visiting home page" do
#     before do
#       visit decidim.root_path
#     end

#     it "shows the original assembly menu" do
#       within ".main-nav" do
#         expect(page).to have_content("Assemblies")
#         expect(page).to have_link(href: "/assemblies")
#       end
#     end

#     it "shows the extra configured menu" do
#       within ".main-nav" do
#         expect(page).to have_content("Local Groups")
#         expect(page).to have_link(href: "/local_groups")
#       end
#     end

#     context "and navigating to original assemblies" do
#       before do
#         within ".main-nav" do
#           click_on "Assemblies"
#         end
#       end

#       it "shows assemblies without excluded types" do
#         expect(page).to have_no_css("#assemblies-filter")
#         within "#parent-assemblies" do
#           expect(page).to have_no_content(alternative_assembly.title["en"])
#           expect(page).to have_content(assembly2.title["en"])
#           expect(page).to have_content(assembly.title["en"])
#         end
#       end

#       it "has the assemblies path" do
#         expect(page).to have_current_path decidim_assemblies.assemblies_path
#       end
#     end

#     context "and navigating to alternative assemblies" do
#       before do
#         within ".main-nav" do
#           click_on "Local Groups"
#         end
#       end

#       it "shows assemblies without excluded types" do
#         within "#parent-assemblies" do
#           expect(page).to have_content(alternative_assembly.title["en"])
#           expect(page).to have_no_content(assembly2.title["en"])
#           expect(page).to have_no_content(assembly.title["en"])
#         end
#       end

#       it "has the alternative path" do
#         expect(page).to have_current_path local_groups_path
#       end

#       context "when filtering by scope" do
#         before do
#           within "#participatory-space-filters" do
#             click_on "Select a scope"
#           end
#           within "#data_picker-modal" do
#             click_on translated(first_scope.name)
#             click_on "Select"
#           end
#         end

#         it "show alternative processes when filtering" do
#           within "#parent-assemblies" do
#             expect(page).to have_content(alternative_assembly.title["en"])
#             expect(page).to have_no_content(assembly2.title["en"])
#             expect(page).to have_no_content(assembly.title["en"])
#           end
#         end

#         it "has the alternative path" do
#           expect(page).to have_current_path(Regexp.new(local_groups_path))
#         end
#       end

#       context "when filtering by area" do
#         before do
#           within "#participatory-space-filters" do
#             select "Select an area"
#             select translated(first_area.name)
#           end
#         end

#         it "show alternative processes when filtering" do
#           within "#parent-assemblies" do
#             expect(page).to have_content(alternative_assembly.title["en"])
#             expect(page).to have_no_content(assembly2.title["en"])
#             expect(page).to have_no_content(assembly.title["en"])
#           end
#         end

#         it "has the alternative path" do
#           expect(page).to have_current_path(Regexp.new(local_groups_path))
#         end
#       end
#     end
#   end

#   context "when accessing original assemblies with an alternative path" do
#     before do
#       visit "/local_groups/#{assembly2.slug}"
#     end

#     it "redirects to the original path" do
#       expect(page).to have_current_path decidim_assemblies.assembly_path(assembly2.slug)
#     end
#   end

#   context "when accessing alternative assemblies with the original path" do
#     before do
#       visit "/assemblies/#{alternative_assembly.slug}"
#     end

#     it "redirects to the alternative path" do
#       expect(page).to have_current_path local_group_path(alternative_assembly.slug)
#     end
#   end

#   context "when accessing non typed assemblies with the alternative path" do
#     before do
#       visit "/local_groups/#{assembly.slug}"
#     end

#     it "redirects to the original path" do
#       expect(page).to have_current_path decidim_assemblies.assembly_path(assembly.slug)
#     end
#   end

#   context "when accessing alternative assembly members page" do
#     before do
#       visit "/local_groups/#{alternative_assembly.slug}/members"
#     end

#     it "shows the members page" do
#       expect(page).to have_content("MEMBERS")
#       expect(page).to have_content(member.full_name)
#     end
#   end

#   context "when accessing alternative assembly widget" do
#     before do
#       visit "/local_groups/#{alternative_assembly.slug}/embed"
#     end

#     it "shows the widget" do
#       expect(page).to have_content(alternative_assembly.title["en"])
#       expect(page).to have_content("MORE INFO")
#     end
#   end
# end
