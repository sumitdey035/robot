require 'rails_helper'

RSpec.describe Toy, type: :model do
  context 'scopes' do
    describe '#placed?' do
      let!(:not_placed_toy)  { create(:toy) }
      let!(:placed_toy)  { create(:toy, x: 0, y: 0, facing: 'NORTH') }

      it "is expected to return false if the toy yet not placed" do
        expect(not_placed_toy.placed?).to be(false)
      end

      it "is expected to return false if the toy is placed" do
        expect(placed_toy.placed?).to be(true)
      end
    end

    describe '#place' do
      let!(:toy)  { create(:toy) }

      it "is expected to raise exception if any of x, y and facing is not present" do
        expect(toy.place(1,2)).to be(false)
        expect(toy.place(2, 'NORTH')).to be(false)
        expect(toy.place(1)).to be(false)
        expect(toy.place('NORTH')).to be(false)
        expect(toy.place()).to be(false)
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
      let!(:last_x_point_toy)   { create(:toy, x: 4, y: 2, facing: 'WEST') }
      let!(:last_y_point_toy)   { create(:toy, x: 3, y: 4, facing: 'SOUTH') }

      it "is expected not to move if the robot is not placed yet" do
        expect{ not_placed_toy.move }.not_to change {not_placed_toy}
      end

      it "is expected to move to the same direction" do
        [north_facing_toy, south_facing_toy, west_facing_toy, east_facing_toy].collect(&:move)
        expect(north_facing_toy.coordinates).to eq([2,1])
        expect(south_facing_toy.coordinates).to eq([2,3])
        expect(west_facing_toy.coordinates).to eq([3,2])
        expect(east_facing_toy.coordinates).to eq([1,2])
      end

      it "is not expected to move if the robot is about to fall" do
        expect{ last_x_point_toy.move }.not_to change {last_x_point_toy}
        expect{ last_y_point_toy.move }.not_to change {last_y_point_toy}
      end
    end

    describe '#left' do
      let!(:not_placed_toy)     { create(:toy) }
      let!(:placed_toy)   { create(:toy, x: 2, y: 2, facing: 'NORTH') }

      it "is expected not to rotate if the robot is not placed yet" do
        expect{ not_placed_toy.left }.not_to change {not_placed_toy}
      end

      it "is expected to rotate left" do
        expect(placed_toy.left).to eq('EAST')
        expect(placed_toy.left).to eq('SOUTH')
        expect(placed_toy.left).to eq('WEST')
        expect(placed_toy.left).to eq('NORTH')
        expect(placed_toy.left).to eq('EAST')
      end
    end

    describe '#right' do
      let!(:not_placed_toy)     { create(:toy) }
      let!(:placed_toy)   { create(:toy, x: 2, y: 2, facing: 'NORTH') }

      it "is expected not to rotate if the robot is not placed yet" do
        expect{ not_placed_toy.right }.not_to change {not_placed_toy}
      end

      it "is expected to rotate right" do
        expect(placed_toy.right).to eq('WEST')
        expect(placed_toy.right).to eq('SOUTH')
        expect(placed_toy.right).to eq('EAST')
        expect(placed_toy.right).to eq('NORTH')
        expect(placed_toy.right).to eq('WEST')
      end
    end
  end
end
