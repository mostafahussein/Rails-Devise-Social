FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    admin { false }
    password { "pass123" }
    password_confirmation { "pass123" }
  end
end