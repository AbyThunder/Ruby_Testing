# You have a class called Map with attributes @height, @width, @cursor
# You have a class called Cursor with attributes @x, @y
# We want a method Map#move() that moves the cursor to the :left, :right, :up, :down
# Map#move(Symbol) -> Map with new cursor

# HINT: Map#move means instance method move, whereas Map.move would mean class method

def assert_eq(expected, &actual)
  actual.call.then { |result| raise "\ngot: #{result.inspect}\nexpected: #{expected.inspect}\n" unless expected == result }
  puts :ok
end

def assert_not_eq(expected, &actual)
  actual.call.then { |result| raise "\ngot: #{result}\nexpected: #{expected}\n" unless expected != result }
  puts :ok
end

def assert_error(expected_error_klass, &actual)
  actual.call
rescue => exception
  raise "" unless exception.is_a?(expected_error_klass)
  puts :ok
else
  raise "expected #{expected_error_klass} to be raised but no error was raised"
end

# assert_error(TypeError) do
#   # code that raises the error
#   raise TypeError
# end

class Map
  def initialize(height, width, cursor)
    @height = height
    @width = width
    @cursor = cursor

    raise ArgumentError, "Invalid map size" unless @height.positive? && @width.positive?
    raise ArgumentError, "Cursor out of bounds" unless cursor.x <= @width && cursor.y <= @height 
  end

  attr_reader :height, :width, :cursor

  def move(direction)
    raise 'invalid direction' unless [:up, :down, :left, :right].include? direction

    with cursor: cursor.send(direction)
  end

  def ==(other)
    @height == other.height && @width == other.width && @cursor == other.cursor
  end

  def with(height: self.height, width: self.width, cursor: self.cursor)
    Map.new(height, width, cursor)
  end
end

class Cursor
  def initialize(x, y)
    @x = x
    @y = y

    raise ArgumentError, "Invalid Cursor Position" unless @x.positive? && @y.positive?
  end

  attr_reader :x, :y

  def ==(other)
    @x == other.x && @y == other.y
  end

  def left
    with(x: x-1)
  end

  def right
    with(x: x+1)
  end

  def down
    with(y: y-1)
  end

  def up
    with(y: y+1)
  end

  def with(x: self.x, y: self.y)
    Cursor.new(x, y)
  end
end

# add two tests for cursor == other_cursor (equal and not equal test)
# add two tests for map == other_map (equal and not equal)

assert_eq(Cursor.new(1, 1)) { Cursor.new(1, 1) }
assert_not_eq(Cursor.new(1, 1)) { Cursor.new(1, 2) }
assert_not_eq(Cursor.new(1, 1)) { Cursor.new(2, 1) }

assert_eq(Map.new(10, 10, Cursor.new(5, 5))) { Map.new(10, 10, Cursor.new(5, 5)) }
assert_not_eq(Map.new(10, 10, Cursor.new(5, 5))) { Map.new(9, 10, Cursor.new(5, 5)) }
assert_not_eq(Map.new(10, 10, Cursor.new(5, 5))) { Map.new(10, 9, Cursor.new(5, 5)) }
assert_not_eq(Map.new(10, 10, Cursor.new(2, 1))) { Map.new(10, 10, Cursor.new(1, 1)) }


assert_eq(Map.new(2, 2, Cursor.new(1, 2))) do 
  Map.new(2, 2, Cursor.new(1, 1)).move(:up)
end

assert_eq(Map.new(2, 2, Cursor.new(2, 1))) do 
  Map.new(2, 2, Cursor.new(2, 2)).move(:down)
end

assert_eq(Map.new(10, 10, Cursor.new(5, 5))) do 
  Map.new(10, 10, Cursor.new(6, 5)).move(:left)
end

assert_eq(Map.new(2, 2, Cursor.new(2, 2))) do 
  Map.new(2, 2, Cursor.new(1, 2)).move(:right)
end

# When **creating** a new map, if the cursor is out of bounds, an error should be raised
# A cursor is out of bounds if index is NOT between [1 and height/width]

# x or y cursor position to high
assert_error(ArgumentError) { Map.new(10, 10, Cursor.new(100, 10)) }
assert_error(ArgumentError) { Map.new(10, 10, Cursor.new(10, 100)) }

#invalid map
assert_error(ArgumentError) { Map.new(0, 10, Cursor.new(10, 10)) }
assert_error(ArgumentError) { Map.new(10, 0, Cursor.new(10, 10)) }

#Cursor out of bounds
assert_error(ArgumentError) { Cursor.new(0, 10) }
assert_error(ArgumentError) { Cursor.new(10, 0) }
