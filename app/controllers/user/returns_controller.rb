class User::ReturnsController < ApplicationController
  def index
    @returns = current_user.returns
  end

  def return_product
    #byebug
    @return_product = Return.new()
    @return_product.order = Order.find(params[:order_id])
    @return_product.user = current_user
    @return_product.status = 0
    if @return_product.save
      byebug
      redirect_to user_order_returns_path, notice: 'Devolução Aberta com Sucesso'
    else
      redirect_to user_orders_path, alert: 'Devolução não foi aberta com sucesso'
    end
  end
end