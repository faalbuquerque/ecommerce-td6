class HomeController < ApplicationController
  def index
    @products = Product.all
    @categories = Category.where(ancestry: nil)
  end
end
