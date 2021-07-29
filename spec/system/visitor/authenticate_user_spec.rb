require 'rails_helper'

describe 'authenticating user' do
  context 'visitor' do
    context 'cart' do
      it 'GET index' do
        visit my_orders_users_carts_path

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      it 'GET order' do
        visit order_users_cart_path(id: 1)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      it 'GET index' do
        visit users_carts_path

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      it 'GET show' do
        visit users_cart_path(id: 1)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
    end
    context 'evaluations' do
      it 'GET' do
        visit edit_users_evaluation_path(id: 1)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
    end
  end
end
