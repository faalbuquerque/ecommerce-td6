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
      fill_in 'Altura', with: 0.31
      fill_in 'Largura', with: 0.42
      fill_in 'Comprimento', with: 0.53
      fill_in 'Peso', with: 1
      select 'Sim', from: 'Frágil?'
      attach_file('product_picture', Rails.root.join('spec/fixtures/files/product.jpg'))
      expect { click_on 'Registrar' }.to change { Product.count }.by(1)

      expect(page).to have_content('Produto 1')
      expect(page).to have_content('Marca 1')
      expect(page).to have_content('R$ 20')
      expect(page).to have_content('Descrição sobre produto 1')
      expect(page).to have_content('Altura: 0.31 m')
      expect(page).to have_content('Largura: 0.42 m')
      expect(page).to have_content('Comprimento: 0.53 m')
      expect(page).to have_content('Frágil')
    end

    it 'and attributes cannot be blank' do
      admin = create(:admin)

      login_as admin, scope: :admin
      visit products_path
      click_on 'Adicionar Produto'
      click_on 'Registrar' 

      expect(page).to have_content('não pode ficar em branco', count: 8)
    end

    it 'and sku must be unique' do
      admin = create(:admin)
      create(:product, sku: '123456abcdef')
    
      login_as admin, scope: :admin
      visit products_path
      click_on 'Adicionar Produto'
      fill_in 'SKU', with: '123456abcdef'
      click_on 'Registrar' 
      
      expect(page).to have_content('já está em uso')
    end

  end
end
# check('Fragil')
# <div class="field form-group">
#    <%= f.label :fragile %>
#    <%= f.check_box :fragile %>
# </div>
