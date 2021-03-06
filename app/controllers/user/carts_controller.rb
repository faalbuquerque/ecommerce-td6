class User::CartsController < User::UsersController
  before_action :find_cart, only: %i[show order]
  before_action :find_product, only: %i[create update]
  before_action :check_shipping, only: %i[update]
  before_action :setting_evaluation, only: %i[order]

  def index
    @carts = current_user.carts.pending
  end

  def show; end

  def create
    @cart = current_user.carts.new(carts_params)
    redirect_to user_carts_path, notice: t('.success') if @cart.save!
  end
  # rubocop:disable Metrics/AbcSize

  def update
    @cart = current_user.carts.find(params[:id])
    return redirect_to user_cart_path(@cart), notice: t('.shipping_failure') unless notificate_shipping(params)

    if @cart.update(service_order: @service_order)
      redirect_to user_cart_path(@cart), notice: t('.success')
    else
      @cart.pending!
      redirect_to user_cart_path(@cart)
    end
  end
  # rubocop:enable Metrics/AbcSize

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
      shipping_time: shipping['arrival_time'], shipping_price: shipping['price'],
      warehouse_code: shipping['warehouse_code'] }
  end

  def check_shipping
    @shipping = Shipping.chosen!(params[:cart][:shipping_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to user_carts_path, alert: t('.required_shipping')
  end

  def find_cart
    @cart = Cart.find(params[:id])
  end

  def find_product
    @product = Product.find(params[:product_id])
    @stock = Stock.to_product(sku: @product.sku)
  end

  def notificate_shipping(params)
    @address = Address.find(params[:cart][:address_id])
    @cart.update(**create_params, status: 1)
    @service_order = Shipping.selling_conclusion(@cart, @address)
    Stock.reservation(@cart, @service_order) if @service_order
  end

  def setting_evaluation
    @user_evaluation = current_user.evaluations.where(product: @cart.product)
    @evaluation = Evaluation.new
  end
end
