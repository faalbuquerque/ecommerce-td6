require 'rails_helper'

describe 'User management' do
  context 'registration' do
    it 'success' do
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'matheus@hotmail.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123456'
      click_on 'Criar conta'

      expect(current_path).to eq(root_path)
      expect(page).to have_text('Login efetuado com sucesso')
      expect(page).to have_link('Sair')
    end

    it 'and logout' do
      user = create(:user)

      login_as user, scope: :user
      visit root_path
      click_on 'Sair'

      expect(page).to have_text('Saiu com sucesso')
      expect(page).to_not have_text(user.email)
      expect(page).to_not have_link('Sair')
      expect(page).to have_link('Entrar')
      expect(page).to have_link('Registrar-me')
    end

    it 'and confirmation password is diferent from password' do
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'matheus@hotmail.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '098765'
      click_on 'Criar conta'

      expect(page).to have_text('Confirmação de Senha não é igual a Senha')
    end
  end
end
