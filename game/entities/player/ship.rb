class Ship
  attr_accessor :ship, :image_url

  def initialize(image_url, size, x, y, rows, cols, board)
    @image_url = image_url
    @rows = rows
    @cols = cols
    @board = board
    @initial_x = x
    @initial_y = y
    @size = size
    @ship = Image.new(image_url, width: 40, height: size * 40, z: 50, x: @initial_x, y: @initial_y, rotate: 0)
    @orientation = :vertical
  end

  def draw
    @ship.draw
  end

  def move_left
    if @orientation == :vertical
      if @ship.x > @initial_x
        @ship.x -= 42
      end
    elsif @orientation == :horizontal
      if @ship.x > @initial_x + 42 * ((@size - 1).to_f / 2 )
        @ship.x -= 42
      end
    end
  end

  def move_right
    if @orientation == :vertical
      if @ship.x < @initial_x + 42 * (@cols - 1)
        @ship.x += 42
      end
    elsif @orientation == :horizontal
      if @ship.x < @initial_x + 42 * (@cols - 1) - 42 * ((@size-1).to_f / 2 )
        @ship.x += 42
      end
    end
  end

  def move_up
    if @orientation == :vertical
      if @ship.y > @initial_y
        @ship.y -= 42
      end
    elsif @orientation == :horizontal
      if @ship.y > @initial_y - 42 * ((@size - 1).to_f / 2 )
        @ship.y -= 42
      end
    end
  end

  def move_down
    if @orientation == :vertical
      if @ship.y < @initial_y + 42 * (@rows - 1) - @ship.height
        @ship.y += 42
      end
    elsif @orientation == :horizontal
      if @ship.y < @initial_y + 42 * (@rows - 1) - @ship.height + 42 * ((@size-1).to_f / 2 )
        @ship.y += 42
      end
    end
  end

  def move_rotate
    if @ship.rotate == 0
      @ship.rotate = 90
      @orientation = :horizontal
      if @ship.x > @initial_x + 42 * (@cols - @size)
        @ship.x -= 42 * ((@size - 1).to_f / 2 )
      else
        @ship.x += 42 * ((@size - 1).to_f / 2 )
      end
      
      @ship.y -= 42 * ((@size - 1).to_f / 2)
    else
      @ship.rotate = 0
      @orientation = :vertical
      @ship.x -= 42 * ((@size - 1).to_f / 2 )

      if @ship.y > @initial_y + 42 * (@rows - @size - 1)
        @ship.y -= 42 * ((@size - 1).to_f / 2 )
      else
        @ship.y += 42 * ((@size - 1).to_f / 2 )
      end
    end
  end

  def enter
    positions = []

    if @orientation == :vertical
      (0...@size).each do |i|
        row = (@ship.y - @initial_y) / 42 + i
        col = (@ship.x - @initial_x) / 42
        positions << [row, col]
      end
    else
      (0...@size).each do |i|
        row = ((@ship.y - @initial_y) / 42) + (0.5 * (@size - 1))
        col = ((@ship.x - @initial_x) / 42 + i) - (0.5 * (@size - 1))
        positions << [row, col]
      end
    end

    positions.each do |row, col|
      if row < 0 || row >= @board.size || col < 0 || col >= @board[0].size || @board[row][col] != 0
        return false
      end
    end

    positions.each { |row, col| @board[row][col] = 1 }

    return true, @board
  end
end