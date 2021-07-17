require 'rails_helper'

describe 'Account Management' do
  context 'Login' do
    it 'with email and password' do
      create(:admin, email: 'admin@mercadores.com.br', password: '123456')

      visit admin_root_path
      fill_in 'Email', with: 'admin@mercadores.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'

      expect(page).to have_text('admin@mercadores.com.br')
      expect(page).to have_text('Login efetuado com sucesso')
      expect(current_path).to eq(admin_root_path)
      expect(page).to have_link('Sair')
    end

    it 'fields blank' do
      visit admin_root_path
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      click_on 'Entrar'

      expect(page).to have_text('Email ou senha inválida')
    end

    it 'wrong password' do
      create(:admin, email: 'admin@mercadores.com.br', password: '123456')

      visit admin_root_path
      fill_in 'Email', with: 'admin@mercadores.com.br'
      fill_in 'Senha', with: '111111'
      click_on 'Entrar'

      expect(page).to have_text('Email ou senha inválida')
    end
  end

  context 'Registration new admin' do
    it 'admin registers other admin' do
      admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')

      login_as admin, scope: :admin

      visit admin_root_path
      click_on 'Administradores'
      click_on 'Cadastrar novo administrador'
      fill_in 'Email', with: 'other_admin@mercadores.com.br'
      click_on 'Criar Admin'

      expect(page).to have_text('Novo administrador cadastrado!')
      expect(page).to have_text('other_admin@mercadores.com.br')
      expect(current_path).to have_text(admin_registration_admins_path)
    end

    it "new admin email can't be blank" do
      admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')

      login_as admin, scope: :admin

      visit admin_root_path
      click_on 'Administradores'
      click_on 'Cadastrar novo administrador'
      fill_in 'Email', with: ''
      click_on 'Criar Admin'

      expect(page).to have_text('não pode ficar em branco')
      expect(current_path).to have_text(admin_registration_admins_path)
    end

    it 'view registered admins' do
      admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
      create(:admin, email: 'supervisor@mercadores.com.br')
      create(:admin, email: 'manager@mercadores.com.br')

      login_as admin, scope: :admin

      visit admin_root_path
      click_on 'Administradores'

      expect(page).to have_text('Administradores')
      expect(page).to have_text('supervisor@mercadores.com.br')
      expect(page).to have_text('manager@mercadores.com.br')
    end

    it 'need to be logged to index' do
      visit admin_registration_admins_path

      expect(page).to have_text('Para continuar, efetue login ou registre-se.')
      expect(current_path).to eq(new_admin_session_path)
    end

    it 'need to be logged to new' do
      visit new_admin_registration_admin_path

      expect(page).to have_text('Para continuar, efetue login ou registre-se.')
      expect(current_path).to eq(new_admin_session_path)
    end
  end
end
