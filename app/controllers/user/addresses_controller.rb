class User::AddressesController < ApplicationController
  def index
    @addresses = Address.where(user: current_user)
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.create(address_params.merge(user: current_user))

    if @address.save
      redirect_to [:user, @address], notice: 'Endereço adicionado com sucesso'
    else
      render :new
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  private

  def address_params
    params.require(:address).permit(:state, :city, :cep, :neighborhood, :street, :number, :details, :user)
  end
end
