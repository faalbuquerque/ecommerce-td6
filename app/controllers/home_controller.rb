class HomeController < ApplicationController
  def index
    @products = Product.all
    @categories = Category.where(ancestry: nil)
  end

  def search
    @products = Product.where('lower(name) LIKE lower(?) OR lower(brand) LIKE lower(?)',
                              "%#{params[:query]}%", "%#{params[:query]}%").where(status: 'active')
  end
end
