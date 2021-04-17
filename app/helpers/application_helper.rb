# frozen_string_literal: true

module ApplicationHelper
  def participatory_space_filters_form_url
    if request.path.remove("/").in?(
      [
        *ParticipatoryProcessesScoper.scoped_participatory_process_slug_prefixes.map { |hash| hash[:key] },
        *AssembliesScoper.alternative_assembly_types.map { |hash| hash[:key] }
      ]
    )
      request.path
    else
      url_for
    end
  end
end
