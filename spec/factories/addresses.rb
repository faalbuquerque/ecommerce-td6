FactoryBot.define do
  factory :address do
    user
    state { 'SP' }
    city { 'São Paulo' }
    cep { '15370-496' }
    neighborhood { 'Sede' }
    street { 'Avenida Paulista' }
    number { '1300' }
    details { 'Proximo ao McDonalds' }
  end
end
