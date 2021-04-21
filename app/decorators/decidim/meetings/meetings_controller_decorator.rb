# frozen_string_literal: true

Decidim::Meetings::MeetingsController.class_eval do
  private

  def meetings
    @meetings ||= paginate(ordered_results)
  end

  def ordered_results
    Decidim::Meetings::MeetingSort.new(search.results.not_hidden).sort
  end
end
