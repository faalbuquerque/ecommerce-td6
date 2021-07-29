require 'rails_helper'

describe 'Visitor search products' do
  it 'successfully - full name product' do
    create(:product, name: 'Chocolate 123')
    create(:product, name: 'Biscoito')

    visit root_path
    fill_in 'Buscar Produtos', with: 'Chocolate 123'
    find('button#search_btn').click

    expect(page).to have_link('Chocolate 123')
    expect(page).to_not have_link('Biscoito')
  end

  it 'successfully - part of the name' do
    create(:product, name: 'Chocolate 123')
    create(:product, name: 'Chocolate amargo')
    create(:product, name: 'Chocolate ao leite')
    create(:product, name: 'Coxinha')

    visit root_path
    fill_in 'Buscar Produtos', with: 'Choco'
    find('button#search_btn').click

    expect(page).to have_link('Chocolate 123')
    expect(page).to have_link('Chocolate amargo')
    expect(page).to have_link('Chocolate ao leite')
    expect(page).to_not have_link('Coxinha')
  end

  it 'successfully - product with number in name' do
    create(:product, name: 'Chocolate 123')
    create(:product, name: 'Chocolate 321')

    visit root_path
    fill_in 'Buscar Produtos', with: '123'
    find('button#search_btn').click

    expect(page).to have_link('Chocolate 123')
    expect(page).to_not have_link('Chocolate 321')
  end

  it 'failure - no products with name' do
    create(:product, name: 'Pizza')

    visit root_path
    fill_in 'Buscar Produtos', with: 'Doce de leite'
    find('button#search_btn').click

    expect(page).to have_text('Nenhum resultado encontrado!')
    expect(page).to_not have_text('Pizza')
  end
end
