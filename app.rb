# require 'system'
require 'io/console'

class Model # crunchs numbers
  def initialize
    @expression = [] # store expression values
    @syntaxError = false
  end

  def evaluate # evaluate expression


    if @syntaxError
      "SYNTAX ERROR"
    end

  end

  def getExpression
    @expression

  end

  def addValue(value)
    @expression.push(value)
  end

  def clearValues
    @expresion = []
  end

end

class Controller # handles input
  def initialize(model, view)
    @calcModel = model
    @calcView = view

    @validChars = ['1','2','3','4','5','6','7','8','9','0','+','-','*','/','.','=','\r','q']
    @exitChars = ['q']
    @state = 'init'
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

    if isValid
      @calcModel.addValue(inputChar)
    end

    @calcView.render(inputChar, isValid)

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
| ( | ) | % | c |
|---+---+---+---|
| 7 | 8 | 9 | / |
|---+---+---+---|
| 4 | 5 | 6 | * |
|---+---+---+---|
| 1 | 2 | 3 | - |
|---+---+---+---|
| 0 | . | = | + |
 ---------------
'

  end

  def render(inputChar, isValid) # render view
    Gem.win_platform? ? (system "cls") : (system "clear")
    print @calculatorFace
    puts "Keypressed: #{inputChar}, was #{isValid ? "valid" : "invalid"}"
  end
end

def main
  calcModel = Model.new
  calcView = View.new
  calcController = Controller.new(calcModel,calcView)
  calcController.start
end

main
