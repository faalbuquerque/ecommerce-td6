class Users::CartsController < User::UsersController
  before_action :find_cart, only: %i[show order]
  before_action :find_apis, only: %i[create]
  before_action :check_shipping, only: %i[update]
  before_action :setting_evaluation, only: %i[order]

  def index
    @carts = current_user.carts.where(status: 'pending')

    # shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))

    # result = JSON.parse(shippings_json, symbolize_names: true)
    # @shippings = Shipping.from_json_array(result)
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
    return flash.now[:notice] = 'Fora de estoque' unless Stock.to_product(sku: @cart.product.sku)

    return redirect_to users_cart_path(@cart), notice: t('.shipping_failure') unless notificate_shipping(params)

    if @cart.update(service_order: @service_order)
      redirect_to users_cart_path(@cart), notice: t('.success')
    else
      @cart.pending!
      redirect_to users_cart_path(@cart)
    end
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
      shipping_time: shipping['arrival_time'], shipping_price: shipping['price'],
      warehouse_code: shipping['warehouse_code'] }
  end

  def check_shipping
    raise ActiveRecord::RecordNotFound if params[:cart][:shipping_id].blank?

    @shipping = Shipping.chosen(params[:cart][:shipping_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_carts_path, alert: t('.required_shipping')
  end

  def find_cart
    @cart = Cart.find(params[:id])
  end

  def find_apis
    @product = Product.find(params[:product_id])
    @shipping = Shipping.chosen(params[:shipping_id])
    @stock = Stock.to_product(sku: @product.sku)
  end

  def notificate_shipping(params)
    @address = Address.find(params[:cart][:address_id])
    @cart.update(**create_params, status: 1)
    @service_order = Shipping.selling_conclusion(@cart, @address)
    if @service_order
      Stock.reservation(@cart, @service_order) 
    end
  end

  def setting_evaluation
    @user_evaluation = current_user.evaluations.where(product: @cart.product)
    @evaluation = Evaluation.new
  end
end
