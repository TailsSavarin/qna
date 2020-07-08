module QuestionsHelper
  def number_of(questions)
    questions.count == 1 ? ' question' : ' questions'
  end
end
