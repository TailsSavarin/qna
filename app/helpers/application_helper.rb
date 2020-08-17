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

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
