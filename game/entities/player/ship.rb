class Ship
  attr_accessor :ship, :image_url

  def initialize(image_url, size, x, y, rows, cols, board)
    @image_url = image_url
    @rows = rows
    @cols = cols
    @board = board
    @initial_x = x
    @initial_y = y
    @block_size = App.class_variable_get(:@@canvas).block_size
    @size = size
    @ship = Image.new(image_url, width: @block_size, height: size * @block_size, z: 50, x: @initial_x, y: @initial_y, rotate: 0)
    @orientation = :vertical
  end

  def draw
    @ship.draw
  end

  def move_left
    if @orientation == :vertical
      if @ship.x > @initial_x
        @ship.x -= @block_size + 2
      end
    elsif @orientation == :horizontal
      if @ship.x > @initial_x + (@block_size + 2) * ((@size - 1).to_f / 2 )
        @ship.x -= @block_size + 2
      end
    end
  end

  def move_right
    if @orientation == :vertical
      if @ship.x < @initial_x + (@block_size + 2) * (@cols - 1)
        @ship.x += (@block_size + 2)
      end
    elsif @orientation == :horizontal
      if @ship.x < @initial_x + (@block_size + 2) * (@cols - 1) - (@block_size + 2) * ((@size-1).to_f / 2 )
        @ship.x += (@block_size + 2)
      end
    end
  end

  def move_up
    if @orientation == :vertical
      if @ship.y > @initial_y
        @ship.y -= (@block_size + 2)
      end
    elsif @orientation == :horizontal
      if @ship.y > @initial_y - (@block_size + 2) * ((@size - 1).to_f / 2 )
        @ship.y -= (@block_size + 2)
      end
    end
  end

  def move_down
    if @orientation == :vertical
      if @ship.y < @initial_y + (@block_size + 2) * (@rows - 1) - @ship.height
        @ship.y += (@block_size + 2)
      end
    elsif @orientation == :horizontal
      if @ship.y < @initial_y + (@block_size + 2) * (@rows - 1) - @ship.height + (@block_size + 2) * ((@size-1).to_f / 2 )
        @ship.y += (@block_size + 2)
      end
    end
  end

  def move_rotate
    if @ship.rotate == 0
      @ship.rotate = 90
      @orientation = :horizontal
      if @ship.x > @initial_x + (@block_size + 2) * (@cols - @size)
        @ship.x -= (@block_size + 2) * ((@size - 1).to_f / 2 )
      else
        @ship.x += (@block_size + 2) * ((@size - 1).to_f / 2 )
      end
      
      @ship.y -= (@block_size + 2) * ((@size - 1).to_f / 2)
    else
      @ship.rotate = 0
      @orientation = :vertical
      @ship.x -= (@block_size + 2) * ((@size - 1).to_f / 2 )

      if @ship.y > @initial_y + (@block_size + 2) * (@rows - @size - 1)
        @ship.y -= (@block_size + 2) * ((@size - 1).to_f / 2 )
      else
        @ship.y += (@block_size + 2) * ((@size - 1).to_f / 2 )
      end
    end
  end

  def enter
    positions = []

    if @orientation == :vertical
      (0...@size).each do |i|
        row = (@ship.y - @initial_y) / (@block_size + 2) + i
        col = (@ship.x - @initial_x) / (@block_size + 2)
        positions << [row, col]
      end
    else
      (0...@size).each do |i|
        row = ((@ship.y - @initial_y) / (@block_size + 2)) + (0.5 * (@size - 1))
        col = ((@ship.x - @initial_x) / (@block_size + 2) + i) - (0.5 * (@size - 1))
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