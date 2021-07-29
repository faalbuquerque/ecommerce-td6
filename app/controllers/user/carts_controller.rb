class User::CartsController < ApplicationController
  def index
    @carts = current_user.carts
  end
end
