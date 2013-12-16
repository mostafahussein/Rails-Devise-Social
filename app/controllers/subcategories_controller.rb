class SubcategoriesController < ApplicationController
  def index
    @subcategories = Subcategory.of_category(params[:category])
    respond_to do |format|
	   format.html
	   format.json { render :json => @subcategories }
	end
  end
end
