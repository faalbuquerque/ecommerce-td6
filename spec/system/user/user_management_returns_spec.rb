require 'rails_helper'

describe 'user management returns product' do
  it 'succesfully' do
    user = create(:user)
    create(:cart, user: user, delivery_date: 1.day.ago, status: 5, service_order: 'SOWUXRR4p6')
    login_as user, scope: :user
    visit root_path

    click_on 'Meus Pedidos'
    click_on 'Solicitar Devolução'

    expect(page).to have_text('Devolução Aberta com Sucesso')
    expect(page).to have_text('Aguardando coleta da Transportadora')
  end

  it 'not available if 7 days passed' do
    user = create(:user)
    create(:cart, user: user, delivery_date: 8.days.ago)
    login_as user, scope: :user

    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to_not have_link('Solicitar Devolução')
  end

  it 'cannot request return if product is returned' do
    user = create(:user)
    cart = create(:cart, user: user)
    create(:return, user: user, cart: cart, status: 10)
    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Minhas Devoluções'

    expect(user_carts_path).to_not have_link('Solicitar Devolução')
    expect(page).to have_text('Produto Devolvido com Sucesso')
  end

  it 'view return status' do
    user = create(:user)
    cart1 = create(:cart, user: user)
    cart2 = create(:cart, user: user)
    cart3 = create(:cart, user: user)
    create(:return, user: user, cart: cart1, status: 0)
    create(:return, user: user, cart: cart2, status: 5)
    create(:return, user: user, cart: cart3, status: 10)

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Minhas Devoluções'

    expect(page).to have_text('Aguardando coleta da Transportadora')
    expect(page).to have_text('Produto a Caminho')
    expect(page).to have_text('Produto Devolvido com Sucesso')
  end
end
