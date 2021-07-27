class User::ReturnsController < ApplicationController
  def index
    @returns = current_user.returns
  end

  def return_product
    @return_product = Return.new
    @return_product.cart = Cart.find(params[:id])
    @return_product.user = current_user
    @return_product.status = 0
    redirect_to user_returns_path, notice: 'Devolução Aberta com Sucesso' if @return_product.save!
  end
end
