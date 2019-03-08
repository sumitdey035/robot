# frozen_string_literal: true

FactoryBot.define do
  factory :toy, class: Toy do
    name  { Faker::Name.name }
  end
end
