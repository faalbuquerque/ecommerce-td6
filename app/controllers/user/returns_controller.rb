class User::ReturnsController < ApplicationController
  def index
    @returns = current_user.returns
  end

  def return_product
    cart = Cart.find(params[:id])
    return unless cart.elegible_for_return

    @return_product = current_user.returns.new(cart: cart)
    redirect_to user_returns_path, notice: t('.success') if @return_product.save!
  end
end
