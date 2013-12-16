FactoryGirl.define do
  factory :project do
    budget { 10000 }
    currency { 'CHF' }
    start_date {Date.today}
    end_date {Date.today + 6.months}
    description {Faker::Lorem.sentences}
    user
  end
end