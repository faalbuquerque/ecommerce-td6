require 'rails_helper'

describe 'user evaluates product' do
  it 'create successfully' do
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
    expect { click_on 'Publicar' }.to change { Evaluation.count }.by(1)

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
  it 'editing evaluation' do
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
    expect { click_on 'Atualizar' }.to change { Evaluation.count }.by(0)

    expect(page).to have_content(2)
    expect(page).to have_content('Algum comentário 2')
  end
  it 'creating missing params' do
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
    fill_in 'Avaliação', with: ''
    fill_in 'Comentário', with: ''
    expect { click_on 'Publicar' }.to change { Evaluation.count }.by(0)

    expect(page).to have_content('não pode ficar em branco', count: 1)
  end
  it 'editing missig parameters' do
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
    fill_in 'Avaliação', with: ''
    fill_in 'Comentário', with: ''
    expect { click_on 'Atualizar' }.to change { Evaluation.count }.by(0)

    expect(page).to have_content('não pode ficar em branco', count: 1)
  end
  it 'not logged see average rating' do
    user = create(:user, email: 'john@mail.com', password: '123456')
    user2 = create(:user, email: 'user2@mail.com', password: '123456')
    address = create(:address, user: user)
    product = create(:product)
    shipping = Shipping.new(shipping_id: 1, name: 'Frete 1', warehouse_code: 'CAD12',
                            price: 20.0, arrival_time: 1.month.ago)
    create(:cart, product: product, user: user, address: address, status: 1,
                  shipping_id: shipping.shipping_id, service_order: 'wc90ewir')
    create(:cart, product: product, user: user2, address: address, status: 1,
                  shipping_id: shipping.shipping_id, service_order: 'fd9021w4t')
    create(:evaluation, user: user, product: product, rate: 3, comment: 'Comentário novo')
    create(:evaluation, user: user2, product: product, rate: 5, comment: 'Comentário novo 2')
    product.update(average_rating: 4)

    visit root_path
    click_on product.name

    expect(page).to have_content(4.0)
    expect(page).to have_content(2)
    expect(page).to have_content('Comentário novo')
    expect(page).to have_content(5)
    expect(page).to have_content('Comentário novo 2')
  end
end
