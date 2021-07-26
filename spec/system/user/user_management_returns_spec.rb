require 'rails_helper'

describe 'user management returns product' do
  it 'succesfully' do
    user = create(:user)
    create(:order, user: user)
    login_as user, scope: :user
    visit root_path
    
    click_on 'Meus Pedidos'
    save_page
    click_on 'Solicitar Devolução'
    
    #first(:link, 'Solicitar Devolução')
    
    expect(page).to have_text('Devolução Aberta com Sucesso')
    expect(page).to have_text('Aguardando coleta da Transportadora')
    
  end

  it 'not available if 7 days passed' do
    user = create(:user)
    create(:order, user: user, created_at: 8.days.ago)
    login_as user, scope: :user

    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to_not have_link('Solicitar Devolução')
  end

  it 'cannot request return if product is returned' do
    user = create(:user)
    create(:order, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Minhas Devoluções'

    expect(page).to have_text('Produto devolvido com sucesso')
  end

  it 'view return status' do
    user = create(:user)
    order1 = create(:order, user: user)
    order2 = create(:order, user: user)
    order3 = create(:order, user: user)
    create(:return, user: user, order: order1, status: 0)
    create(:return, user: user, order: order2, status: 5)
    create(:return, user: user, order: order3, status: 10)

    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Minhas Devoluções'

    expect(page).to have_text('Aguardando coleta da transportadora')
    expect(page).to have_text('Produto a caminho')
    expect(page).to have_text('Produto devolvido com sucesso')
  end
end
