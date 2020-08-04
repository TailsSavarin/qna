class SearchController < ApplicationController
  def index
    resource = params[:resource]
    query = params[:query]
    @results = SearchService.new(resource, query).call
  end
end
