# require 'system'
require 'io/console'

class Model # crunchs numbers
  def initialize
    @expression = [] # store expression values
  end

  def evaluate # evaluate expression

  end

  def getExpression
    @expression
  end

  def addValue(value)
    @expression.push(value)
  end

end

class Controller # handles input
  def initialize
    @validChars = ['1','2','3','4','5','6','7','8','9','0','+','-','*','/','.','=','\r','q']
    @exitChars = ['q']
    @state = 'init'
    @calcUI = View.new
  end

  def step

    # get input character
    inputChar = STDIN.getch

    # exit on exit char press
    if @exitChars.include?(inputChar)
      exit
    end

    # validate input
    isValid = @validChars.include?(inputChar)

    @calcUI.render(inputChar, isValid)

  end

  def start
    @state = 'running'
    while @state != 'stopped'
      step
    end
  end
end

class View # renders calculator
  def initialize
    @calculatorFace =
' ---------------
| 7 | 8 | 9 | / |
|---+---+---+---|
| 4 | 5 | 6 | * |
|---+---+---+---|
| 1 | 2 | 3 | - |
|---+---+---+---|
| 0 | . | = | + |
 --------------- '

  end

  def render(inputChar, isValid) # render view
    Gem.win_platform? ? (system "cls") : (system "clear")
    puts "Keypressed: #{inputChar}, was #{isValid ? "valid" : "invalid"}"
    print @calculatorFace
  end
end

def main
  calcController = Controller.new
  calcController.start
end

main
