FactoryGirl.define do
  factory :user do |f|
    f.firstname "Hans"
    f.name "Wurst"
    f.password "test1234"
    f.password_confirmation "test1234"
    sequence(:email) { |n| "hans_wurst_#{n}@example.com" }
  end
end