require 'rails_helper'

describe 'Categories management' do
  it 'view categories' do
    admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
    login_as admin, scope: :admin

    create(:category, name: 'tv')
    create(:category, name: 'filmes')
    create(:category, name: 'games')

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

  it 'create with parent category' do
    admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
    create(:category, name: 'Informática')
    login_as admin, scope: :admin

    visit admin_root_path
    click_on 'Categorias'

    click_on 'Adicionar categoria'

    fill_in 'Nome',	with: 'Notebook'
    select 'Ativo',	from: 'Status'
    select 'Informática',	from: 'Categoria Principal'
    click_on 'Criar Categoria'

    expect(page).to have_link('Notebook')
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

    expect(page).to have_content('já está em uso')
  end

  it 'and name cannot be blank' do
    admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
    login_as admin, scope: :admin

    visit admin_root_path
    click_on 'Categorias'

    click_on 'Adicionar categoria'
    fill_in 'Nome', with: ''
    click_on 'Criar Categoria'

    expect(page).to have_content('Nome não pode ficar em branco')
  end

  it 'edit category' do
    admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
    create(:category, name: 'Informática')
    login_as admin, scope: :admin

    visit admin_categories_path

    click_on 'Informática'

    fill_in 'Nome', with: 'Informática e eletronica'
    click_on 'Atualizar Categoria'

    expect(page).to have_content('Informática e eletronica')
  end

  it 'name cannot be blank in edit' do
    admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
    create(:category, name: 'Informática')
    login_as admin, scope: :admin

    visit admin_categories_path

    click_on 'Informática'

    fill_in 'Nome', with: ''
    click_on 'Atualizar Categoria'

    expect(page).to have_content('Nome não pode ficar em branco')
  end

  it 'category principal cant be the same subcategory' do
    admin = create(:admin, email: 'admin@mercadores.com.br', password: '123456')
    create(:category, name: 'Papelaria')
    create(:category, name: 'Informática')
    login_as admin, scope: :admin

    visit admin_categories_path

    click_on 'Informática'

    expect(page).to_not have_select('Categoria Principal', options: ['Informática'])
  end
end
