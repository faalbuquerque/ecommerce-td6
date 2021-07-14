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
      expect(page).to have_content('Peso: 1.0 kg')
      expect(page).to have_content('SKU: 123456abcdef')
      expect(page).to have_content('Frágil')
    end

    it 'and attributes cannot be blank' do
      admin = create(:admin)

      login_as admin, scope: :admin
      visit admin_products_path
      click_on 'Adicionar Produto'
      click_on 'Registrar'

      expect(page).to have_content('não pode ficar em branco', count: 10)
    end

    it 'and sku must be unique' do
      admin = create(:admin)
      create(:product, sku: '123456abcdef', name: 'Produto 1')

      login_as admin, scope: :admin
      visit admin_products_path
      click_on 'Adicionar Produto'
      fill_in 'SKU', with: '123456abcdef'
      click_on 'Registrar'

      expect(page).to have_content('já está em uso')
    end
  end

  context 'view' do
    it 'no product registered' do
      admin = create(:admin)
      Product.last.destroy

      login_as admin, scope: :admin
      visit admin_products_path

      expect(page).to have_content('Nenhum produto cadastrado')
    end

    it 'index' do
      admin = create(:admin)

      product1 = create(:product)
      product2 = create(:product)

      login_as admin, scope: :admin
      visit root_path
      click_on 'Produtos'

      expect(page).to have_content(product1.name)
      expect(page).to have_content(product1.brand)
      expect(page).to have_content('R$ 20,00')
      expect(page).to have_content(product2.name)
      expect(page).to have_content(product2.brand)
    end
    xit 'show' do
    end
  end

  context 'edit' do
    it 'successfully' do
      admin = create(:admin)
      create(:product, name: 'Produto novo')

      login_as admin, scope: :admin
      visit root_path
      click_on 'Produtos'
      click_on 'Produto novo'
      click_on 'Editar'
      fill_in 'Nome', with: 'Produto Alterado'
      fill_in 'Marca', with: 'Marca Alterado'
      fill_in 'Preço', with: 22
      fill_in 'Descrição', with: 'Descrição sobre produto alterado'
      fill_in 'SKU', with: '00000abcdef'
      fill_in 'Altura', with: 1.2
      fill_in 'Largura', with: 0.43
      fill_in 'Comprimento', with: 0.54
      fill_in 'Peso', with: 22
      select 'Não', from: 'Frágil?'
      expect { click_on 'Atualizar' }.to change { Product.count }.by(0)

      expect(page).to have_content('Produto Alterado')
      expect(page).to have_content('Marca Alterado')
      expect(page).to have_content('R$ 22')
      expect(page).to have_content('Descrição sobre produto alterado')
      expect(page).to have_content('Altura: 1.2 m')
      expect(page).to have_content('Largura: 0.43 m')
      expect(page).to have_content('Comprimento: 0.54 m')
      expect(page).to have_content('Peso: 22.0 kg')
      expect(page).to have_content('SKU: 00000abcdef')
      expect(page).to have_content('Não Frágil')
    end

    it 'and attributes cannot be blank' do
      admin = create(:admin)
      product = create(:product, name: 'Produto teste 1')

      login_as admin, scope: :admin
      visit root_path
      click_on 'Produtos'
      click_on product.name
      click_on 'Editar'
      fill_in 'Nome', with: ''
      fill_in 'Marca', with: ''
      fill_in 'Preço', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'SKU', with: ''
      fill_in 'Altura', with: ''
      fill_in 'Largura', with: ''
      fill_in 'Comprimento', with: ''
      fill_in 'Peso', with: ''
      expect { click_on 'Atualizar' }.to change { Product.count }.by(0)

      expect(page).to have_content('não pode ficar em branco', count: 9)
    end

    it 'and sku must be unique' do
      admin = create(:admin)
      create(:product, sku: '123456abcdef', name: 'Produto novo 1')
      create(:product, sku: '00000abcdef', name: 'Produto novo 2')

      login_as admin, scope: :admin
      visit admin_products_path
      click_on 'Produto novo 1'
      click_on 'Editar'
      fill_in 'SKU', with: '00000abcdef'
      click_on 'Atualizar'

      expect(page).to have_content('já está em uso')
    end
  end
end
