# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :projecttask do
    name "MyString"
    project nil
    billable false
  end
end
