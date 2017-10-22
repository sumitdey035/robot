FactoryGirl.define do
  factory :toy, class: Toy do
    name  { Faker::Name.name }
  end
end
