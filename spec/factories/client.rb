FactoryGirl.define do
  factory :client do |f|
    f.name "Testkunde"
    f.description "Ich bin ein Testkunde"
    association :user
  end
end