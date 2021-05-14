# frozen_string_literal: true

Decidim::Consultations::ConsultationsHelper.class_eval do
  # decidim-core/app/helpers/decidim/check_boxes_tree_helper.rb
  def filter_scopes_values
    main_scopes = current_organization.scopes.top_level

    scopes_values = main_scopes.includes(:scope_type, :children).flat_map do |scope|
      Decidim::CheckBoxesTreeHelper::TreeNode.new(
        Decidim::CheckBoxesTreeHelper::TreePoint.new(scope.id.to_s, translated_attribute(scope.name, current_organization)),
        scope_children_to_tree(scope)
      )
    end

    Decidim::CheckBoxesTreeHelper::TreeNode.new(
      Decidim::CheckBoxesTreeHelper::TreePoint.new("", t("decidim.initiatives.application_helper.filter_scope_values.all")),
      scopes_values
    )
  end

  def scope_children_to_tree(scope)
    return unless scope.children.any?

    scope.children.includes(:scope_type, :children).flat_map do |child|
      Decidim::CheckBoxesTreeHelper::TreeNode.new(
        Decidim::CheckBoxesTreeHelper::TreePoint.new(child.id.to_s, translated_attribute(child.name, current_organization)),
        scope_children_to_tree(child)
      )
    end
  end
  # decidim-core/app/helpers/decidim/check_boxes_tree_helper.rb

  def decidim_consultations_question_partial
    decidim_gem_dir = Gem::Specification.find_by_name("decidim").gem_dir # rubocop:disable Rails/DynamicFindBy
    view_path = "decidim-consultations/app/views/decidim/consultations/consultations/_question.html.erb"

    "#{decidim_gem_dir}/#{view_path}"
  end
end
