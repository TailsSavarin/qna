module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down revote]
  end

  def vote_up
    if !current_user&.author_of?(@votable)
      @votable.vote_up(current_user)
      render_json
    else
      render json: {}, status: 422
    end
  end

  def vote_down
    if !current_user&.author_of?(@votable)
      @votable.vote_down(current_user)
      render_json
    else
      render json: {}, status: 422
    end
  end

  def revote
    if !current_user&.author_of?(@votable)
      @votable.revote(current_user)
      render_json
    else
      render json: {}, status: 422
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def render_json
    render json: { id: @votable.id, rating: @votable.rating }
  end
end
