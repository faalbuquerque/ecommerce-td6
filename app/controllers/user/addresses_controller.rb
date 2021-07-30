class User::AddressesController < User::UsersController
  def index
    @addresses = current_user.addresses
  end

  def new
    @address = Address.new
  end

  def create
    @address = current_user.addresses.create(address_params)

    if @address.save
      redirect_to user_addresses_path, notice: 'Endereço adicionado com sucesso'
    else
      render :new
    end
  end

  private

  def address_params
    params.require(:address).permit(:state, :city, :cep, :neighborhood, :street, :number, :details, :user)
  end
end
