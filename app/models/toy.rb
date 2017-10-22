class Toy < ActiveRecord::Base
  MAX_X   = 4
  MAX_Y   = 3
  FACINGS = %w(NORTH EAST SOUTH WEST)

  validates :x, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_X }, allow_blank: true
  validates :y, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_Y }, allow_blank: true
  validates_inclusion_of :facing, in: FACINGS, allow_blank: true

  validates :name, presence: true
  validate :check_placed, on: :update

  def placed?
    [x, y, facing].any?
  end

  def place(*args)
    if args.length == 3
      update(x: args[0], y: args[1], facing: args[2].upcase)
    else
      errors[:base] << 'Check the method and its parameters'
    end
  end

  def move
    case facing
      when 'NORTH'
        new_x = self.x
        new_y = self.y + 1
      when 'EAST'
        new_x = self.x + 1
        new_y = self.y
      when 'SOUTH'
        new_x = self.x
        new_y = self.y - 1
      when 'WEST'
        new_x = self.x - 1
        new_y = self.y
    end

    update(x: new_x, y: new_y)
  end

  def left
    update(facing: FACINGS[FACINGS.index(facing) - 1 ]) if valid?
  end

  def right
    update(facing: FACINGS.reverse[FACINGS.reverse.index(facing) - 1 ]) if valid?
  end

  def report
    check_placed
    [x, y, facing].join(',')
  end

  def coordinates
    [x,y]
  end

  def check_placed
    errors[:base] << 'Toy is not placed yet' unless placed?
  end

  def method_missing(m, *args, &block)
    errors[:base] << "There's no command called #{m} #{args.join(',')} here -- please try again."
  end
end
