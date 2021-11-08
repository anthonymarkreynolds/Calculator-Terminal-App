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
    @validInputChars = ['1','2','3','4','5','6','7','8','9','0','+','-','*','/','\r','q']
    @state = 'init'
    @CalcUI = View.new
  end

  def step

    # get input character
    inputChar = STDIN.getch

    # validate input
    isValid = @validInputChars.include?(inputChar)

    if inputChar == 'q'
      exit
    end

    @CalcUI.render(inputChar, isValid)

  end

  def start
    @state = 'running'
    while @state != 'stopped'
      step
    end
  end
end

class View # renders calculator

  def render(inputChar, isValid) # render view
    puts "Keypressed: #{inputChar} was #{isValid ? "valid" : "invalid"}"
  end
end

calculatorModel = Model.new
calculatorControler = Controller.new
calculatorView = View.new

calculatorControler.start
