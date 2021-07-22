require 'rails_helper'

describe 'User view order' do
  it 'successfully' do
    user = create(:user)
    create(:address, user: user)
    product = create(:product, name: 'Produto 1', price: 10, brand: 'Marca 1')
    cart = create(:cart, product: product, shipping_price: 5, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content('Produto 1')
    expect(page).to have_content('R$ 5,00')
    expect(page).to have_content('R$ 10,00')
    expect(page).to have_content('Marca 1')
  end

  it 'create' do
    user = create(:user, email: 'jhondoe@user.com')
    create(:address, user: user)
    product = create(:product, price: 20, name: 'Produto 1')
    attributes = product.as_json(only: %i[sku weight length width])

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
    one_shipping_json = File.read(Rails.root.join('spec/fixtures/one_shipping.json'))

    allow(Faraday).to receive(:get)
    .with('http://whoknows2', params: { sku: product.sku })
    .and_return(instance_double(Faraday::Response, status: 200,
                                body: stock_json))
    allow(Faraday).to receive(:get)
    .with('http://whoknows', params: { **attributes, cep: '13015301' })
    .and_return(instance_double(Faraday::Response, status: 200,
                                body: shippings_json))
    allow(Faraday).to receive(:get)
    .with('http://whoknows3', params: { shipping_id: '3' })
    .and_return(instance_double(Faraday::Response, status: 200,
                                body: one_shipping_json))

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'CEP', with: '13015301'
    click_on 'Calcular por CEP'
    choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
    click_on 'Adicionar ao carrinho'
    click_on 'Carrinho'
    click_on 'Finalizar Compra'
    

    expect(page).to have_content('Pedido realizado com sucesso!')
    expect(page).to have_content('Produto 1')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('R$ 15,00')
    # expect(page).to have_content('13.0153-01')
    expect(page).to have_content('jhondoe@user.com')
  end
end