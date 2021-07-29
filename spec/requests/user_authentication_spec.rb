require 'rails_helper'

describe 'authenticating user' do
  context 'visitor' do
    context 'cart' do
      xit 'POST' do
        post users_carts_path, params: { cart: { user_id: '1' } }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'evaluations' do
      xit 'POST' do
        post users_evaluations_path, params: { cart: { user_id: 1 } }

        expect(response).to redirect_to(new_user_session_path)
      end
      xit 'PATCH' do
        patch users_evaluation_path(id: 1), params: { cart: { user_id: 1 } }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
