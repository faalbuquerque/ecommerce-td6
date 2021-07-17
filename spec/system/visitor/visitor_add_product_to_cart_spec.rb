require 'rails_helper'

describe 'add products to cart' do
  context 'adding' do
    it 'successfully all products' do
      create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
                        description: 'Descrição sobre este produto', price: 30,height: '2', width: '1',
                        length: '3', weight: '4', sku: 'woeife3483ru')

      visit root_path
      click_on 'Nome do Produto 1'

      expect(page).to have_content('Nome do Produto 1')
      expect(page).to have_content('R$ 30,00')
      expect(page).to have_content('Marca do Produto 1')
    end
    it 'successfully show product' do
      create(:product, name: 'Nome do Produto 1', brand: 'Marca do Produto 1',
              description: 'Descrição sobre este produto', height: '2', width: '1',
              length: '3', weight: '4', sku: 'woeife3483ru')

      visit root_path
      click_on 'Nome do Produto 1'

      expect(page).to have_content('Nome do Produto 1')
      expect(page).to have_content('Descrição sobre este produto')
      expect(page).to have_content('R$ 20')
      expect(page).to have_content('Marca do Produto 1')
      expect(page).to have_content('2.0 m')
      expect(page).to have_content('1.0 m')
      expect(page).to have_content('3.0 m')
      expect(page).to have_content('4.0 kg')
    end
    xit 'successfully add product to cart' do
      product = create(:product, name: 'Produto 1')

      visit root_path
      click_on product.name
      click_on 'Adicionar ao carrinho'
      click_on 'Carrinho'

      expect(page).to have_content(product.name)
      expect(page).to have_content(product.price)
      expect(page).to have_content(product.brand)
      expect(page).to have_content(product.name)
    end
    it 'notify when successfully' do
      product = create(:product, name: 'Produto 1')

      visit root_path
      click_on product.name
      click_on 'Comprar'

      expect(page).to have_content('Produto adicionado ao carrrinho com sucesso!')
    end
  end
end
