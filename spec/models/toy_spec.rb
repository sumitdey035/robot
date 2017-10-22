require 'rails_helper'

RSpec.describe Toy, type: :model do
  let!(:toy)          { create(:toy) }
  let!(:placed_toy)   { create(:toy, x: 2, y: 2, facing: 'NORTH') }

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:x).allow_nil }
    it { is_expected.to validate_numericality_of(:y).allow_nil }
    it { is_expected.to validate_inclusion_of(:facing).in_array(Toy::FACINGS).allow_nil }

    it 'validates that the toy is placed before other operations' do
      toy.move
      expect(toy.errors[:base].size).to eq(1)
      expect(toy.errors[:base]).to eq(["Toy is not placed yet"])
    end
  end

  context 'scopes' do
    describe '#placed?' do
      it "is expected to return false if the toy yet not placed" do
        expect(toy.placed?).to be(false)
      end

      it "is expected to return false if the toy is placed" do
        expect(placed_toy.placed?).to be(true)
      end
    end

    describe '#place' do
      it "is expected to raise exception if any of x, y and facing is not present" do
        expect{ toy.place(1,2) }.to change { toy.errors[:base] }
        expect{ toy.place(2, 'NORTH') }.to change { toy.errors[:base] }
        expect{ toy.place(1) }.to change { toy.errors[:base] }
        expect{ toy.place('NORTH') }.to change { toy.errors[:base] }
        expect{ toy.place }.to change { toy.errors[:base] }
      end

      it "is expected to place the toy with valid x, y and facing" do
        toy.place(1,2,'NORTH')
        expect(toy.x).to eq(1)
        expect(toy.y).to eq(2)
        expect(toy.facing).to eq('NORTH')
      end
    end

    describe '#move' do
      let!(:not_placed_toy)     { create(:toy) }
      let!(:north_facing_toy)   { create(:toy, x: 2, y: 2, facing: 'NORTH') }
      let!(:south_facing_toy)   { create(:toy, x: 2, y: 2, facing: 'SOUTH') }
      let!(:east_facing_toy)    { create(:toy, x: 2, y: 2, facing: 'EAST') }
      let!(:west_facing_toy)    { create(:toy, x: 2, y: 2, facing: 'WEST') }
      let!(:last_x_point_toy)   { create(:toy, x: 3, y: 2, facing: 'WEST') }
      let!(:last_y_point_toy)   { create(:toy, x: 3, y: 3, facing: 'SOUTH') }

      it "is expected not to move if the robot is not placed yet" do
        expect{ not_placed_toy.move }.not_to change {not_placed_toy}
      end

      it "is expected to move to the same direction" do
        [north_facing_toy, south_facing_toy, west_facing_toy, east_facing_toy].collect(&:move)
        expect(north_facing_toy.coordinates).to eq([2,3])
        expect(south_facing_toy.coordinates).to eq([2,1])
        expect(west_facing_toy.coordinates).to eq([1,2])
        expect(east_facing_toy.coordinates).to eq([3,2])
      end

      it "is not expected to move if the robot is about to fall" do
        expect{ last_x_point_toy.move }.not_to change {last_x_point_toy}
        expect{ last_y_point_toy.move }.not_to change {last_y_point_toy}
      end
    end

    describe '#left' do
      it "is expected not to rotate if the robot is not placed yet" do
        expect{ toy.right }.to change { toy.errors[:base] }
      end

      it "is expected to rotate left" do
        expect{ placed_toy.left }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('WEST')

        expect{ placed_toy.left }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('SOUTH')

        expect{ placed_toy.left }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('EAST')

        expect{ placed_toy.left }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('NORTH')

        expect{ placed_toy.left }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('WEST')
      end
    end

    describe '#right' do
      it "is expected not to rotate if the robot is not placed yet" do
        expect{ toy.right }.to change { toy.errors[:base] }
      end

      it "is expected to rotate right" do
        expect{ placed_toy.right }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('EAST')

        expect{ placed_toy.right }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('SOUTH')

        expect{ placed_toy.right }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('WEST')

        expect{ placed_toy.right }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('NORTH')

        expect{ placed_toy.right }.to change { placed_toy.facing }
        expect(placed_toy.facing).to eq('EAST')
      end
    end

    describe '#coordinates' do
      it "is expected not to rotate if the robot is not placed yet" do
        expect(placed_toy.coordinates).to eq([2,2])
      end
    end

    describe '#report' do
      it "is expected not to rotate if the robot is not placed yet" do
        expect(placed_toy.report).to eq('2,2,NORTH')
      end
    end
  end
end
