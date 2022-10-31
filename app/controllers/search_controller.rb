class SearchController < ApplicationController
  def create
    search = Google::RestaurantSearch.new(search_params, current_user)
            
    if search.run 
      render json: search.results.to_json
    else
      render json: { message: search.error }, status: :bad_request
    end
  end 

  private 

  def search_params
    params.require(:search).permit(:keyword, :latitude, :longitude)
  end
end