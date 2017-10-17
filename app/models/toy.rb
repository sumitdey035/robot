class Toy < ActiveRecord::Base
  MAX_X = 4
  MAX_Y = 4
  FACINGS = %w(NORTH WEST SOUTH EAST)

  # validates :x, :y, inclusion: 0..4

  def placed?
    [x, y, facing].any?
  end

  def place(*args)
    return false unless Toy.valid_placed_input?(*args)
    update(x: args[0], y: args[1], facing: args[2].upcase)
  end

  def coordinates
    [x,y]
  end

  def move
    return unless placed?

    case facing
      when 'NORTH'
        new_x = self.x
        new_y = self.y - 1
      when 'EAST'
        new_x = self.x - 1
        new_y = self.y
      when 'SOUTH'
        new_x = self.x
        new_y = self.y + 1
      when 'WEST'
        new_x = self.x + 1
        new_y = self.y
    end

    if Toy.inside_table?(new_x, new_y)
      update(x: new_x, y: new_y)
      return [new_x, new_y]
    end
  end

  def left
    return unless placed?
    self.facing = FACINGS[FACINGS.index(facing) - 1 ]
  end

  def right
    return unless placed?
    self.facing = FACINGS.reverse[FACINGS.reverse.index(facing) - 1 ]
  end

  def self.valid_placed_input?(*args)
    return false unless args.length == 3 # Check no of parameters
    return false unless args.first(2).all?{|x| x.is_a?(Fixnum)} && args.last.is_a?(String) # Check parameter type
    return false unless args[0].between?(0, MAX_X) && args[1].between?(0, MAX_Y) && FACINGS.include?(args[2].upcase) # Check parameter value
    return true
  end

  def self.inside_table?(new_x, new_y)
    new_x.between?(0, MAX_X) && new_y.between?(0, MAX_Y)
  end
end
