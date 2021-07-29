class Users::CartsController < User::UsersController
  before_action :find_product, only: %i[create]
  before_action :find_cart, only: %i[show order]
  before_action :check_shipping, only: %i[update]
  before_action :find_shipping, only: %i[update]
  before_action :find_stock, only: %i[create]
  before_action :find_apis, only: %i[create]
  before_action :setting_evaluation, only: %i[order]

  def index
    @carts = current_user.carts.where(status: 'pending')
  end

  def show; end

  def create
    @cart = current_user.carts.new(carts_params)
    if @cart.save
      redirect_to users_carts_path, notice: t('.success')
    else
      flash.now[:notice] = t('.failure')
      render 'products/show'
    end
  end

  def update
    @cart = current_user.carts.find(params[:id])

    redirect_to users_cart_path(@cart), notice: t('.success') if @cart.update(create_params.merge(status: 'success'))
  end

  def my_orders
    @carts = current_user.carts
  end

  def order
    shipping = Shipping.find_status_by_order(@cart.service_order)
    if shipping.status
      @cart.update(status: shipping.status)
    else
      flash.now[:notice] = 'Atualização de status temporariamente indisponível'
    end
  end

  private

  def carts_params
    params.permit(:address_id, :product_id, :shipping_id)
  end

  def create_params
    params.require(:cart).permit(:address_id, :product_id, :shipping_id).merge(shipping_params)
  end

  def shipping_params
    shipping = JSON.parse(params[:cart][:shipping_id])
    { shipping_id: shipping['shipping_id'], shipping_name: shipping['name'],
      shipping_time: shipping['arrival_time'], shipping_price: shipping['price'] }
  end

  def check_shipping
    raise ActiveRecord::RecordNotFound if params[:cart][:shipping_id].blank?
  rescue ActiveRecord::RecordNotFound
    redirect_to users_carts_path, alert: t('.required_shipping')
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_shipping
    @shipping = Shipping.chosen(params[:cart][:shipping_id])
  end

  def find_apis
    @shipping = Shipping.chosen(params[:shipping_id])
  end

  def find_stock
    @stock = Stock.to_product(sku: @product.sku)
  end

  def find_cart
    @cart = Cart.find(params[:id])
  end

  def setting_evaluation
    @user_evaluation = current_user.evaluations.where(product: @cart.product)
    @evaluation = Evaluation.new
  end
end
