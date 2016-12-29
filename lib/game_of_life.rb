class GameOfLife
  def GameOfLife.nextGeneration(input)
    GameOfLife.validateInput(input)

    firstNumber = input[0].to_i
    secondNumber = input[2].to_i

    grid = input.sub(BEGINNING_REGEX, '')

    array = GameOfLife.convertGridToArray(grid)

    nextGenerationArray = GameOfLife.nextGenerationArray(array)

    GameOfLife.arrayToGrid(nextGenerationArray, firstNumber, secondNumber)
  end

  private
  BEGINNING_REGEX = /\A[0-9] [0-9]\n/m
  ALIVE = "*"
  DEAD = "."

  def GameOfLife.validateInput(input)
    if !(input =~ BEGINNING_REGEX)
      raise "Expected two numbers separated by a space at the beginning"
    end

    firstNumber = input[0].to_i
    secondNumber = input[2].to_i

    input = input.sub(BEGINNING_REGEX, '')

    if !(input =~ /\A(?:[\.\*]{8}\n){4}\Z/m)
      raise "Expected array of dots (.) and stars (*) that are #{secondNumber} x #{firstNumber}"
    end
  end

  def GameOfLife.convertGridToArray(input)
    rows = input.split("\n")
    return rows.map { |row| row.split("") }
  end

  def GameOfLife.nextGenerationAtPoint(array, x, y)
    aliveNeighborCount = GameOfLife.aliveNeighborCount(array, x, y)

    if aliveNeighborCount == 3 || (aliveNeighborCount == 2 && GameOfLife.valueAt(array, x, y) == ALIVE)
      ALIVE
    else
      DEAD
    end
  end

  def GameOfLife.aliveNeighborCount(array, x, y)
    neighbors = GameOfLife.generateNeighborLocations(array, x, y)

    neighbors.reduce(0) do |sum, neighbor|
      if neighbor && GameOfLife.valueAt(array, neighbor[0], neighbor[1]) == ALIVE
        sum + 1
      else
        sum
      end
    end
  end

  def GameOfLife.valueAt(array, x, y)
    array[y][x]
  end

  def GameOfLife.generateNeighborLocations(array, x, y)
    top = y - 1
    left = x - 1
    bottom = y == array.length - 1 ? -1 : y + 1
    right = x == array[0].length - 1 ? -1 : x + 1

    locations = []

    locations << GameOfLife.generateLocation(left, top)
    locations << GameOfLife.generateLocation(x, top)
    locations << GameOfLife.generateLocation(right, top)
    locations << GameOfLife.generateLocation(right, y)
    locations << GameOfLife.generateLocation(right, bottom)
    locations << GameOfLife.generateLocation(x, bottom)
    locations << GameOfLife.generateLocation(left, bottom)
    locations << GameOfLife.generateLocation(left, y)
  end

  def GameOfLife.generateLocation(x, y)
    return nil if x < 0 || y < 0
    [x, y]
  end

  def GameOfLife.nextGenerationArray(array)
    array.each_with_index.map do |line, y|
      line.each_with_index.map do |value, x|
        GameOfLife.nextGenerationAtPoint(array, x, y)
      end
    end
  end

  def GameOfLife.arrayToGrid(array, height, width)
    height.to_s + " " + width.to_s + "\n" + array.reduce("") do | sum, line |
      sum + line.reduce("") do | sum, char |
        sum + char
      end + "\n"
    end
  end
end
