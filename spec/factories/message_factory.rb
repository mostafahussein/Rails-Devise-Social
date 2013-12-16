FactoryGirl.define do
  factory :message do
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.sentences }
  end
end