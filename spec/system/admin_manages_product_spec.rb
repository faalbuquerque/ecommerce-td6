require 'rails_helper'

describe 'Admin manages products' do
  context 'create' do
    it 'successfully' do
      admin = create(:admin)

      login_as admin, scope: :admin
      visit root_path
      click_on 'Produtos'
      click_on 'Adicionar Produto'
      fill_in 'Nome', with: 'Produto 1'
      fill_in 'Marca', with: 'Marca 1'
      fill_in 'Preço', with: 20
      fill_in 'Descrição', with: 'Descrição sobre produto 1'
      fill_in 'SKU', with: '123456abcdef'
      fill_in 'Altura', with: 0.3
      fill_in 'Largura', with: 0.4
      fill_in 'Comprimento', with: 0.5
      check('Frágil')
      attach_file('product_picture', Rails.root.join('spec/fixtures/files/product.jpg'))
      expect { click_on 'Registrar' }.to change { Product.count }.by(1)

      expect(current_page).to have_content('Produto 1')
      expect(current_page).to have_content('Marca 1 1')
      expect(current_page).to have_content('R$ 20')
      expect(current_page).to have_content('Descrição sobre produto 1')
      expect(current_page).to have_content('Altura: 0.3 m')
      expect(current_page).to have_content('Largura: 0.4 m')
      expect(current_page).to have_content('Comprimento: 0.5 m')
      expect(current_page).to have_content('Frágil')
    end
  end
end
