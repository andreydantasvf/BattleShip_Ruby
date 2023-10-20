module Shared
  class Canvas
    attr_reader :height, :width, :margin

    def initialize
      @width = 1280
      @height = 720
      @margin = 10
    end
  end
end