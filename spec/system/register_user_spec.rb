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

    xit 'logout' do
    end

    xit 'password invalid' do
    end
  end
end