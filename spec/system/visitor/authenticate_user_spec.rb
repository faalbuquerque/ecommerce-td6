require 'rails_helper'

describe 'authenticating user' do
  context 'visitor' do
    context 'cart' do
      it 'GET index' do
        visit my_orders_user_carts_path

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      it 'GET order' do
        visit order_user_cart_path(id: 1)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      it 'GET index' do
        visit user_carts_path

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      it 'GET show' do
        visit user_cart_path(id: 1)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
    end
    context 'evaluations' do
      it 'GET' do
        visit edit_user_evaluation_path(id: 1)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
    end
  end
end
