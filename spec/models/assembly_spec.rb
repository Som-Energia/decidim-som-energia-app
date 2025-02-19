# frozen_string_literal: true

require "rails_helper"

module Decidim
  describe Assembly do
    let(:first_type) { create(:assemblies_type) }
    let(:second_type) { create(:assemblies_type) }
    let!(:first_assembly) { create(:assembly, slug: "slug1", assembly_type: type1) }
    let!(:second_assembly) { create(:assembly, slug: "slug2", assembly_type: type2) }
    let!(:third_assembly) { create(:assembly, slug: "slug3", assembly_type: nil) }

    it "assemblies have types assigned" do
      expect(first_assembly.decidim_assemblies_type_id).to eq(first_type.id)
      expect(second_assembly.decidim_assemblies_type_id).to eq(second_type.id)
      expect(third_assembly.decidim_assemblies_type_id).to be_nil
    end

    context "when no scope types" do
      before do
        Assembly.scope_to_types(nil, nil)
      end

      it "has no default scope" do
        expect(Assembly.all.to_sql).not_to include("WHERE")
        expect(Assembly.scope_types).not_to be_present
        expect(Assembly.scope_types_mode).not_to be_present
      end

      it "find all assemblies" do
        assemblies = Assembly.all
        expect(assemblies).to include(first_assembly)
        expect(assemblies).to include(second_assembly)
        expect(assemblies).to include(third_assembly)
      end
    end

    context "when scope types are in :include mode" do
      before do
        Assembly.scope_to_types([first_type.id], :include)
      end

      it "has a default scope" do
        expect(Assembly.all.to_sql).to include("WHERE")
        expect(Assembly.scope_types).to eq([first_type.id])
        expect(Assembly.scope_types_mode).to eq(:include)
      end

      it "find only included assemblies" do
        assemblies = Assembly.all
        expect(assemblies).to include(first_assembly)
        expect(assemblies).not_to include(second_assembly)
        expect(assemblies).not_to include(third_assembly)
      end
    end

    context "when scope types are in :exclude mode" do
      before do
        Assembly.scope_to_types([second_type.id], :exclude)
      end

      it "has a default scope" do
        expect(Assembly.all.to_sql).to include("WHERE")
        expect(Assembly.scope_types).to eq([second_type.id])
        expect(Assembly.scope_types_mode).to eq(:exclude)
      end

      it "find only non-included assemblies" do
        assemblies = Assembly.all
        expect(assemblies).to include(first_assembly)
        expect(assemblies).not_to include(second_assembly)
        expect(assemblies).to include(third_assembly)
      end
    end
  end
end
