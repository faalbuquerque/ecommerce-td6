require 'rails_helper'

describe 'user evaluates product' do
  it 'successfully' do
    user = create(:user, email: 'john@mail.com', password: '123456')
    address = create(:address, user: user)
    product = create(:product)
    shipping = Shipping.new(shipping_id: 1, name: 'Frete 1', warehouse_code: 'CAD12',
                            price: 20.0, arrival_time: 1.month.ago)
    create(:cart, product: product, user: user, address: address, status: 1,
                  shipping_id: shipping.shipping_id, service_order: 'wc90ewir')

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on product.name
    fill_in 'Avaliação', with: 5
    fill_in 'Comentário', with: 'Algum comentário'
    click_on 'Publicar'

    expect(page).to have_content(5)
    expect(page).to have_content('Algum comentário')
  end
  it 'cannot evaluate twice' do
    user = create(:user, email: 'john@mail.com', password: '123456')
    address = create(:address, user: user)
    product = create(:product)
    shipping = Shipping.new(shipping_id: 1, name: 'Frete 1', warehouse_code: 'CAD12',
                            price: 20.0, arrival_time: 1.month.ago)
    create(:cart, product: product, user: user, address: address, status: 1,
                  shipping_id: shipping.shipping_id, service_order: 'wc90ewir')
    create(:evaluation, user: user, product: product)

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on product.name

    expect(page).to_not have_button('Publicar')
  end
  it 'editar evaluation' do
    user = create(:user, email: 'john@mail.com', password: '123456')
    address = create(:address, user: user)
    product = create(:product)
    shipping = Shipping.new(shipping_id: 1, name: 'Frete 1', warehouse_code: 'CAD12',
                            price: 20.0, arrival_time: 1.month.ago)
    create(:cart, product: product, user: user, address: address, status: 1,
                  shipping_id: shipping.shipping_id, service_order: 'wc90ewir')
    create(:evaluation, user: user, product: product)

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on product.name
    click_on 'Editar Avaliação'
    fill_in 'Avaliação', with: 2
    fill_in 'Comentário', with: 'Algum comentário 2'
    click_on 'Atualizar'

    expect(page).to have_content(2)
    expect(page).to have_content('Algum comentário 2')
  end
end
