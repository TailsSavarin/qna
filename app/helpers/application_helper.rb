module ApplicationHelper
  def hide_vote_button_for(resource)
    current_user&.voted_for?(resource) ? 'hidden' : ''
  end

  def show_vote_button_for(resource)
    current_user&.voted_for?(resource) ? '' : 'hidden'
  end

  def creation_time(resource)
    resource.created_at.to_s(:short)
  end
end
