require 'rails_helper'

describe 'User view order' do
  it 'successfully' do
    user = create(:user)
    address = create(:address, user: user)
    product = create(:product, name: 'Produto 1', price: 10, brand: 'Marca 1')
    create(:cart, product: product, shipping_price: 5, user: user, address: address)

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
    create(:address, user: user, street: 'Avenida Paulista', city: 'São Paulo', state: 'SP',
                     cep: '15370496', neighborhood: 'Sede', number: '1300')
    product = create(:product, price: 20, name: 'Produto 1')
    attributes = product.as_json(only: %i[sku weight length width])

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
    one_shipping_json = File.read(Rails.root.join('spec/fixtures/one_shipping.json'))

    find_stock_product(product.sku, stock_json)
    find_shippings(attributes, shippings_json, user.addresses.first.cep)
    find_shipping(one_shipping_json)

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'CEP', with: '15370496'
    click_on 'Calcular por CEP'

    click_on 'Adicionar ao carrinho'
    click_on 'Carrinho'
    choose('Avenida Paulista - 1300 - Sede - São Paulo - SP - 15370496')
    click_on 'Calcular valor de entrega'
    choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
    click_on 'Finalizar Compra'

    expect(page).to have_content('Pedido realizado com sucesso!')
    expect(page).to have_content('Produto 1')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('R$ 15,00')
    expect(page).to have_content('15370496')
    expect(page).to have_content('jhondoe@user.com')
  end

  it 'without select address' do
    user = create(:user, email: 'jhondoe@user.com')
    create(:address, user: user, street: 'Avenida Paulista', city: 'São Paulo', state: 'SP',
                     cep: '15370496', neighborhood: 'Sede', number: '1300')
    product = create(:product, price: 20, name: 'Produto 1')
    attributes = product.as_json(only: %i[sku weight length width])

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
    one_shipping_json = File.read(Rails.root.join('spec/fixtures/one_shipping.json'))

    find_stock_product(product.sku, stock_json)
    find_shippings(attributes, shippings_json, user.addresses.first.cep)
    find_shipping(one_shipping_json)

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'CEP', with: '15370496'
    click_on 'Calcular por CEP'

    click_on 'Adicionar ao carrinho'
    click_on 'Carrinho'
    click_on 'Calcular valor de entrega'

    expect(page).to have_content('Selecione um endereço')
  end

  it 'without select address' do
    user = create(:user, email: 'jhondoe@user.com')
    create(:address, user: user, street: 'Avenida Paulista', city: 'São Paulo', state: 'SP',
                     cep: '15370496', neighborhood: 'Sede', number: '1300')
    product = create(:product, price: 20, name: 'Produto 1')
    attributes = product.as_json(only: %i[sku weight length width])

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))
    one_shipping_json = File.read(Rails.root.join('spec/fixtures/one_shipping.json'))

    find_stock_product(product.sku, stock_json)
    find_shippings(attributes, shippings_json, user.addresses.first.cep)
    find_shipping(one_shipping_json)

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'CEP', with: '15370496'
    click_on 'Calcular por CEP'

    click_on 'Adicionar ao carrinho'
    click_on 'Carrinho'
    choose('Avenida Paulista - 1300 - Sede - São Paulo - SP - 15370496')
    click_on 'Calcular valor de entrega'
    click_on 'Finalizar Compra'

    expect(page).to have_content('Selecione o frete')
  end
end
