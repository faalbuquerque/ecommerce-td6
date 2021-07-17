class User::AddressesController < ApplicationController
  def index; end

  def new
    @address = Address.new
  end

  def create
    @address = Address.create(address_params)
    @address.user = current_user
    if @address.save
      #byebug
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
