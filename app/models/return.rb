class Return < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :cart, optional: true
  enum status: { 'Aguardando coleta da Transportadora': 0, 'Produto a Caminho': 5, 'Produto Devolvido com Sucesso': 10 }
end
