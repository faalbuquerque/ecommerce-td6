class User::AddressesController < ApplicationController
  def index
    @addresses = current_user.addresses
  end

  def new
    @address = Address.new
  end

  def create
    @address = current_user.addresses.create(address_params)

    if @address.save
      redirect_to [:user, @address], notice: 'Endereço adicionado com sucesso'
    else
      render :new
    end
  end

  def show
    @address = current_user.addresses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to user_addresses_path, notice: 'Endereço não encontrado'
  end

  private

  def address_params
    params.require(:address).permit(:state, :city, :cep, :neighborhood, :street, :number, :details, :user)
  end
end
