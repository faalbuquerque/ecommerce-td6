class HomeController < ApplicationController
  def index
    @products = Product.all
    @categories = Category.where(ancestry: nil)
  end

  def search
    @products = Product.where('lower(name) LIKE lower(:term) OR lower(brand) LIKE lower(:term)',
                              term: "%#{params[:query]}%").where(status: 'active')
  end
end
