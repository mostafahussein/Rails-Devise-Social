FactoryGirl.define do
  factory :attachment do
    file {File.new("#{Rails.root}/spec/resources/test.docx")}
  end
end