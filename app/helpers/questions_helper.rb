module QuestionsHelper
  def count_of(questions)
    pluralize(questions.count, 'question')
  end
end
