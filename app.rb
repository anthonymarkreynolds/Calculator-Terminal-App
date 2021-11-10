# require 'system'
require 'io/console'
require 'dentaku'

class Model # crunchs numbers

  def initialize
    @expression = '' # store expression values
    @calculator = Dentaku::Calculator.new
    @state = 'input'
  end

  def evaluate # evaluate expression
    result = @calculator.evaluate(@expression)
    @expression = result ? 'ANS: '+result.to_s : 'SYNTAX ERROR'
    @state = 'output'
  end

  def getExpression
    @expression
  end

  def handleInput(value)
    case value
      when 'c'
        @expression = ''
      when '=','\r'
        self.evaluate
      else
        if @state == 'output'
          @state = 'input'
          @expression = value
        else
          @expression += value
        end
    end
  end
end

class Controller
  def initialize(model, view)
    @calcModel = model
    @calcView = view

    @validChars = ['1','2','3','4','5','6','7','8','9','0','+','-','*','(',')','%','/','.','=','\r','q','c']
    @exitChars = ['q']
    @state = 'init'
    @clearCmd = Gem.win_platform? ?  "cls" :  "clear"
  end

  def step

    # get input character
    inputChar = STDIN.getch

    # exit on exit char press
    if @exitChars.include?(inputChar)
      @state = 'stopped'
      system @clearCmd
      print @calcView.exitMessage
      exit
    end

    # validate input
    isValid = @validChars.include?(inputChar)

    if isValid
      @calcModel.handleInput(inputChar)
    end

    system @clearCmd
    print @calcView.render(inputChar, isValid, @calcModel.getExpression)
  end

  def start
    @state = 'running'
    system @clearCmd
    print @calcView.render
    while @state != 'stopped'
      step
    end
  end
end

class View # renders calculator
  def initialize
    @calculatorTop =
'
 ---------------
'
    @calculatorFace =
'
|---------------
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

  def exitMessage
    "Exiting..."
  end

  def render(inputChar = '', isValid = false, expression = '') # render view
    (inputChar != '' ?
      "#{isValid ? '' : 'Invalid key: ' + inputChar}"
    :
      "Enter an expression"
    ) + @calculatorTop + '| ' + expression  + @calculatorFace + 'Type keys shown above
q to quit'
  end
end

def main
  calcModel = Model.new
  calcView = View.new
  calcController = Controller.new(calcModel,calcView)
  calcController.start
end

main
