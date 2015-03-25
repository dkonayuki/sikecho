module TeachersHelper
  def prepare_view_content
    @subjects = current_university.subjects.order('notes_count DESC, year DESC')
    @faculties = current_university.faculties
  end
end
