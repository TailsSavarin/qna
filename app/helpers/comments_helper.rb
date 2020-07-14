module CommentsHelper
  def creation_time(comment)
    comment.created_at.to_s(:short)
  end
end
