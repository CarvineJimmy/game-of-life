require 'game_of_life'

describe GameOfLife do
  validGrid = '........
....*...
...**...
........
'

validInput2 = '4 8
........
.****...
...**...
........
'

validInput = '4 8
' + validGrid

validOutput = '4 8
........
...**...
...**...
........
'

validOutput2 = '4 8
..**....
..*.*...
....*...
........
'

  invalidInputWithGrid = '4 8
..........'

  validArray =
  [
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", "*", ".", ".", "."],
    [".", ".", ".", "*", "*", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."]
  ]

  validArray2 =
  [
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", "*", "*", "*", "*", ".", ".", "."],
    [".", ".", ".", "*", "*", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."]
  ]

  outputArray =
  [
    [".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", "*", "*", ".", ".", "."],
    [".", ".", ".", "*", "*", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."]
  ]

  outputArray2 =
  [
    [".", ".", "*", "*", ".", ".", ".", "."],
    [".", ".", "*", ".", "*", ".", ".", "."],
    [".", ".", ".", ".", "*", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", "."]
  ]

  describe 'nextGeneration' do
    it 'does not error on valid input' do
      expect{ GameOfLife.nextGeneration(validInput) }.not_to raise_error
    end

    it 'errors on invalid input' do
      expect{ GameOfLife.nextGeneration(invalidInputWithGrid) }.to raise_error("Expected array of dots (.) and stars (*) that are 8 x 4")
    end

    it 'returns expected grid' do
      expect(GameOfLife.nextGeneration(validInput)).to eq(validOutput)
      expect(GameOfLife.nextGeneration(validInput2)).to eq(validOutput2)
    end
  end

  describe 'validateInput' do
    it 'does not error on valid input' do
      expect{ GameOfLife.validateInput(validInput) }.not_to raise_error
    end

    it 'errors on incorrectly formatted grid size' do
      expect{ GameOfLife.validateInput('abc') }.to raise_error("Expected two numbers separated by a space at the beginning")
    end

    it 'errors on incorrectly formatted grid' do
        expect{ GameOfLife.validateInput(invalidInputWithGrid) }.to raise_error("Expected array of dots (.) and stars (*) that are 8 x 4")
    end
  end

  describe 'convertGridToArray' do
    it 'correctly converts grid to array' do
      expect(GameOfLife.convertGridToArray(validGrid)).to eql(validArray)
    end
  end

  describe 'nextGenerationAtPoint' do
    it 'returns alive for 3 neighbors' do
      expect(GameOfLife.nextGenerationAtPoint(validArray, 3, 1)).to eq("*")
    end

    it 'returns alive for 2 neighbors when it is already alive' do
      expect(GameOfLife.nextGenerationAtPoint(validArray, 4, 1)).to eq("*")
    end

    it 'returns dead for 2 neighbors when it is dead' do
      expect(GameOfLife.nextGenerationAtPoint(validArray, 5, 1)).to eq(".")
    end

    it 'returns dead for more than 3 neighbors' do
      expect(GameOfLife.nextGenerationAtPoint(validArray2, 3, 1)).to eq(".")
    end

    it 'returns dead for less than 2 neighbors' do
      expect(GameOfLife.nextGenerationAtPoint(validArray2, 1, 1)).to eq(".")
    end
  end

  describe 'aliveNeighborCount' do
    it 'returns correct value' do
      expect(GameOfLife.aliveNeighborCount(validArray, 0, 0)).to eq(0)
      expect(GameOfLife.aliveNeighborCount(validArray, 3, 1)).to eq(3)
      expect(GameOfLife.aliveNeighborCount(validArray, 4, 1)).to eq(2)
    end
  end

  describe 'valueAt' do
    it 'returns correct value for 0, 0' do
      expect(GameOfLife.valueAt(validArray, 0, 0)).to eq(".")
    end

    it 'returns correct value for 1, 0' do
      expect(GameOfLife.valueAt(validArray, 1, 0)).to eq(".")
    end

    it 'returns correct value for 4, 1' do
      expect(GameOfLife.valueAt(validArray, 4, 1)).to eq("*")
    end

    it 'returns correct value for 7, 3' do
      expect(GameOfLife.valueAt(validArray, 7, 3)).to eq(".")
    end
  end

  describe 'generateNeighborLocations' do
    it 'returns 8 [x, y] pairs on a location not near any edges' do
      expect(GameOfLife.generateNeighborLocations(validArray, 2, 2)).to eql([
        [1, 1],
        [2, 1],
        [3, 1],
        [3, 2],
        [3, 3],
        [2, 3],
        [1, 3],
        [1, 2],
      ])
    end

    it 'return 3 [x, y] pairs and 5 nils on a location in a corner' do
      expect(GameOfLife.generateNeighborLocations(validArray, 0, 0)).to eql([
        nil,
        nil,
        nil,
        [1, 0],
        [1, 1],
        [0, 1],
        nil,
        nil,
      ])
    end

    it 'return 5 [x, y] pairs and 3 nils on a location in a corner' do
      expect(GameOfLife.generateNeighborLocations(validArray, 1, 0)).to eql([
        nil,
        nil,
        nil,
        [2, 0],
        [2, 1],
        [1, 1],
        [0, 1],
        [0, 0],
      ])
    end
  end

  describe 'generateLocation' do
    it 'returns x and y in an array when neither are negative' do
      expect(GameOfLife.generateLocation(1, 1)).to eql([1, 1])
    end

    it 'returns nil when x is negative' do
      expect(GameOfLife.generateLocation(-1, 1)).to eq(nil)
    end

    it 'returns nil when y is negative' do
      expect(GameOfLife.generateLocation(1, -1)).to eq(nil)
    end
  end

  describe 'nextGenerationArray' do
    it 'returns expected next generation' do
      expect(GameOfLife.nextGenerationArray(validArray)).to eq(outputArray)
      expect(GameOfLife.nextGenerationArray(validArray2)).to eq(outputArray2)
    end
  end

  describe 'arrayToGrid' do
    it 'returns array to correct string' do
      expect(GameOfLife.arrayToGrid(validArray, 4, 8)).to eq(validInput)
      expect(GameOfLife.arrayToGrid(validArray2, 4, 8)).to eq(validInput2)
    end
  end
end
