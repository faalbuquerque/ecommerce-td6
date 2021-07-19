require 'rails_helper'

describe 'Categories management' do
    it 'view categories' do
      admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
      login_as admin, scope: :admin

      category = create(:category, name:'tv')
      category = create(:category, name:'filmes')
      category = create(:category, name:'games')

      visit admin_root_path
      click_on 'Categorias'

      expect(page).to have_link('tv')
      expect(page).to have_link('filmes')
      expect(page).to have_link('games')
      expect(current_path).to eq(admin_categories_path)
  end

  it 'create new category' do
    admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
    login_as admin, scope: :admin

    visit admin_root_path
    click_on 'Categorias'

    click_on 'Adicionar categoria'

    fill_in 'nome',	with: 'Tv'
    fill_in 'status',	with: 'enable'
    click_on 'Criar Categoria'

    expect(page).to have_link('tv')
    expect(current_path).to eq(admin_categories_path)
  end
end
