require 'rails_helper'

describe 'User view order' do
  it 'successfully' do
    user = create(:user)
    address = create(:address, user: user)
    product = create(:product, name: 'Produto 1')
    create(:cart, product: product, user: user, address: address)

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content('Produto 1')
  end

  it 'create' do
    user = create(:user, email: 'jhondoe@user.com')
    create(:address, user: user, street: 'Avenida Paulista', city: 'São Paulo', state: 'SP',
                     cep: '15370496', neighborhood: 'Sede', number: '1300')
    product = create(:product, name: 'Produto 1', brand: 'Marca do Produto 1',
                               description: 'Descrição sobre este produto',
                               price: 20, height: '2', width: '1',
                               length: '3', weight: '4', sku: 'woeife3483ru')
    attributes = product.as_json(only: %i[sku weight length width height])

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))

    find_stock_product(product.sku, stock_json)
    find_shippings(attributes, shippings_json, user.addresses.first.cep)

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'CEP', with: '15370496'
    click_on 'Calcular por CEP'
    click_on 'Adicionar ao carrinho'
    choose('Avenida Paulista - 1300 - Sede - São Paulo - SP - 15370496')
    click_on 'Calcular valor de entrega'
    choose('Frete 1 - Preço: R$ 15,00 - Prazo de entrega: 10 dias úteis')
    click_on 'Finalizar Compra'

    expect(page).to have_content('Pedido realizado com sucesso!')
    expect(page).to have_content('Produto 1')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('15370496')
    expect(page).to have_content('jhondoe@user.com')
  end

  it 'without select address' do
    user = create(:user, email: 'jhondoe@user.com')
    create(:address, user: user, street: 'Avenida Paulista', city: 'São Paulo', state: 'SP',
                     cep: '15370496', neighborhood: 'Sede', number: '1300')
    product = create(:product, price: 20, name: 'Produto 1')
    attributes = product.as_json(only: %i[sku weight length width height])

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))

    find_stock_product(product.sku, stock_json)
    find_shippings(attributes, shippings_json, user.addresses.first.cep)

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'CEP', with: '15370496'
    click_on 'Calcular por CEP'
    click_on 'Adicionar ao carrinho'
    click_on 'Calcular valor de entrega'

    expect(page).to have_content('Selecione um endereço')
  end

  it 'without select address' do
    user = create(:user, email: 'jhondoe@user.com')
    create(:address, user: user, street: 'Avenida Paulista', city: 'São Paulo', state: 'SP',
                     cep: '15370496', neighborhood: 'Sede', number: '1300')
    product = create(:product, price: 20, name: 'Produto 1')
    attributes = product.as_json(only: %i[sku weight length width height])

    shippings_json = File.read(Rails.root.join('spec/fixtures/shippings.json'))
    stock_json = File.read(Rails.root.join('spec/fixtures/product_stock.json'))

    find_stock_product(product.sku, stock_json)
    find_shippings(attributes, shippings_json, user.addresses.first.cep)

    login_as user, scope: :user
    visit root_path
    click_on 'Produto 1'
    fill_in 'CEP', with: '15370496'
    click_on 'Calcular por CEP'
    click_on 'Adicionar ao carrinho'
    choose('Avenida Paulista - 1300 - Sede - São Paulo - SP - 15370496')
    click_on 'Calcular valor de entrega'
    click_on 'Finalizar Compra'

    expect(page).to have_content('Obrigatório escolher o frete para adicionar ao carrinho')
  end
end
