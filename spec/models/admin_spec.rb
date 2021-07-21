require 'rails_helper'

describe Admin do
  context 'validation' do
    it { should validate_presence_of(:email).with_message('não pode ficar em branco') }
    it { should validate_presence_of(:password).with_message('não pode ficar em branco').on(:update) }
    it { should validate_length_of(:password).is_at_least(6) }
    it 'email with invalid domain' do
      admin = Admin.new(email: 'admin@anyone.com')

      admin.valid?

      expect(admin.errors[:email]).to include('não é válido')
    end

    it 'email with valid domain' do
      admin = Admin.new(email: 'admin@mercadores.com.br')

      expect(admin.save!).to be_truthy
    end

    it 'email must to be uniq' do
      create(:admin, email: 'admin@mercadores.com.br')
      admin = Admin.new(email: 'admin@mercadores.com.br')

      admin.valid?

      expect(admin.errors[:email]).to include('já está em uso')
    end
  end
end
