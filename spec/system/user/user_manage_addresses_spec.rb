require 'rails_helper'

describe 'manage addresses' do
  it 'add address' do
    user = create(:user)

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Perfil'
    click_on 'Meus Endereços'
    click_on 'Adicionar Endereço'
    fill_in 'Estado', with: 'SP'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'CEP', with: '15370-496'
    fill_in 'Bairro', with: 'Sede'
    fill_in 'Logradouro', with: 'Avenida Paulista'
    fill_in 'Número', with: '1300'
    fill_in 'Complemento', with: 'Proximo ao McDonalds'
    click_on 'Adicionar'
    #byebug
    expect(page).to have_text('Avenida Paulista')
    expect(page).to have_text('1300')
    expect(page).to have_text('Proximo ao McDonalds')
    expect(page).to have_text('15370-496')
    expect(page).to have_text('São Paulo')
  end
end
