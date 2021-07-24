class Users::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.carts
  end
end