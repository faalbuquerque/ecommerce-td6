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

    fill_in 'Nome',	with: 'Tv'
    select 'Ativo',	from: 'Status'
    click_on 'Criar Categoria'

    expect(page).to have_link('Tv')
    expect(current_path).to eq(admin_categories_path)
  end

  it 'and name must be uniq' do
    admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
    create(:category, name: 'Informática')
    login_as admin, scope: :admin

    visit admin_root_path
    click_on 'Categorias'

    click_on 'Adicionar categoria'
    fill_in 'Nome', with: 'Informática'
    select 'Inativo', from: 'Status'
    click_on 'Criar Categoria'

    expect(page).to have_content('Já está em uso')
  end
end
