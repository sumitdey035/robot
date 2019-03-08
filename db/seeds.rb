# frozen_string_literal: true

3.times { Toy.create(name: Faker::Name.name) }

7.times { Toy.create(name: Faker::Name.name, x: (0..4).to_a.sample, y: (0..4).to_a.sample, facing: Toy::FACINGS.sample) }
