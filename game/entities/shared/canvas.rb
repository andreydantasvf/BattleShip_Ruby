module Shared
  class Canvas
    attr_reader :height, :width, :margin
    attr_accessor :block_size

    def initialize
      @width = 1280
      @height = 720
      @margin = 10
      @block_size = 35
    end
  end
end