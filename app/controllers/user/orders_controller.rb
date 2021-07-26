class User::OrdersController < ApplicationController
    def index
      @orders = current_user.orders
    end

    

    def show
      @order = Order.find(params[:id])
    end

    private
    def return_params
      params.permit(:return).require(:status, :order, :user)
    end
end