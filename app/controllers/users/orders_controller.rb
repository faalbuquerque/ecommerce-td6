class Users::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.carts
  end

  def show
    @order = current_user.carts.find(params[:id])
    flash[:notice] = 'Pedido realizado com sucesso!'
  end
end