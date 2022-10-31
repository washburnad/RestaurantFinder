class FavoritesController < ApplicationController
  def create
    favorite = current_user.favorites.find_or_initialize_by(favorite_params)
                
    if favorite.save 
      render json: { message: 'Favorite successfully saved' }
    else
      render json: { message: 'Favorite failed to save' }, status: :bad_request
    end
  end 

  def destroy
    favorite = current_user.favorites.find_by(place_id: params[:place_id])
        
    if favorite.nil? 
      render json: { message: 'Favorite not found' }, status: :not_found
    elsif favorite.destroy
      render json: { message: 'Favorite successfully deleted' }
    else
      render json: { message: 'Favorite failed to delete' }, status: :bad_request
    end    
  end

  private

  def favorite_params
    params.require(:favorite).permit(:place_id)
  end
end