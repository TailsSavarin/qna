module CommentsHelper
  def commentable_link(resource)
    if resource.commentable.is_a?(Question)
      link_to "C: #{resource.commentable.title}", question_path(resource.commentable)
    else
      link_to "C: #{resource.commentable.body}", question_path(resource.commentable.question)
    end
  end
end
