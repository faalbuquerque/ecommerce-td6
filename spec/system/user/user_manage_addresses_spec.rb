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

    expect(page).to have_text('Avenida Paulista')
    expect(page).to have_text('1300')
    expect(page).to have_text('Proximo ao McDonalds')
    expect(page).to have_text('15370-496')
    expect(page).to have_text('São Paulo')
    expect(page).to have_text('SP')
  end

  it 'view all addresses' do
    user = create(:user)
    user2 = create(:user, email: 'janedoe@email.com')
    create(:address, street: 'Avenida Paulista', number: '1300', neighborhood: 'Sede',
                     cep: '15370-496', state: 'SP', city: 'São Paulo', user: user)
    create(:address, street: 'Avenida Brasil', number: '645', user: user)
    create(:address, cep: '08390-258', neighborhood: 'Jardim São Francisco',
                     street: 'Travessa ACM', number: '1234', user: user2)

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Perfil'
    click_on 'Meus Endereços'

    expect(page).to have_text('Avenida Paulista')
    expect(page).to have_text('1300')
    expect(page).to have_text('Proximo ao McDonalds')
    expect(page).to have_text('15370-496')
    expect(page).to have_text('São Paulo')
    expect(page).to have_text('SP')
    expect(page).to have_text('Avenida Brasil')
    expect(page).to have_text('645')
    expect(page).to_not have_text('Travessa ACM')
    expect(page).to_not have_text('1234')
  end

  it 'with parameters blank' do
    user = create(:user)

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Perfil'
    click_on 'Meus Endereços'
    click_on 'Adicionar Endereço'
    click_on 'Adicionar'

    expect(page).to have_text('não pode ficar em branco', count: 6)
    expect(current_path).to eq(user_addresses_path)
  end

  it 'can not access other user address' do
    user = create(:user, email: 'john@mail.com')
    user2 = create(:user, email: 'janedoe@email.com')
    create(:address, street: 'Avenida Paulista', number: '1300', user: user)
    create(:address, cep: '08390-258', neighborhood: 'Jardim São Francisco',
                     street: 'Travessa ACM', number: '1234', user: user2)

    login_as user, scope: :user
    visit user_addresses_path

    expect(page).to_not have_text('Travessa ACM')
    expect(page).to_not have_text('1234')
  end

  it 'and cannot create addresses without login' do
    visit new_user_address_path

    expect(current_path).to eq(new_user_session_path)
  end

  it 'and cannot view user profile page' do
    visit user_profile_path

    expect(current_path).to eq(new_user_session_path)
  end
end
