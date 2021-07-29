require 'rails_helper'

RSpec.describe 'authenticating user', type: :request do
  context 'visitor' do
    context 'cart' do
      it 'POST' do
        post users_carts_path, params: { cart: { user_id: '1' } }

        expect(last_response.headers['location']).to be == 'http://example.org/users/sign_in'
      end
    end
    context 'evaluations' do
      it 'POST' do
        post users_evaluations_path, params: { cart: { user_id: 1 } }

        expect(last_response.headers['location']).to be == 'http://example.org/users/sign_in'
      end
      it 'PATCH' do
        patch users_evaluation_path(id: 1), params: { cart: { user_id: 1 } }

        expect(last_response.headers['location']).to be == 'http://example.org/users/sign_in'
      end
    end
  end
end
