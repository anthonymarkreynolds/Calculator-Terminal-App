# require 'system'
require 'io/console'

class Model # crunchs numbers
  def initialize
    @expression = '' # store expression values
  end


  def evaluate # evaluate expression

    # split by non-numbers
    chunks = @expression.split(/([\+\-\/\(\)%\*])/).reject(&:empty?)
    puts chunks


    tokens = chunks.map do |chunk|
      type = case chunk
             when '+'
               'PLUS'
             when '-'
               'MINUS'
             when '*'
               'MULTIPLY'
             when '/'
               'DIVIDE'
             when '%'
               'PERCENT'
             when '('
               'OPEN_PAREN'
             when ')'
               'CLOSE_PAREN'
             else
               'NUM'
             end
      {
        type: type,
        value: chunk
      }
    end

    tokens.each { |token|
      puts token
    }

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
        @expression += value
    end
  end
end

class Controller # handles input
  def initialize(model, view)
    @calcModel = model
    @calcView = view

    @validChars = ['1','2','3','4','5','6','7','8','9','0','+','-','*','(',')','%','/','.','=','\r','q','c']
    @exitChars = ['q']
    @state = 'init'
  end

  def step

    # get input character
    inputChar = STDIN.getch

    # exit on exit char press
    if @exitChars.include?(inputChar)
      @state = 'stopped'
      @calcView.exitMessage
      exit
    end

    # validate input
    isValid = @validChars.include?(inputChar)

    if isValid
      @calcModel.handleInput(inputChar)
    end

    @calcView.render(inputChar, isValid, @calcModel.getExpression )

  end

  def start
    @state = 'running'
    @calcView.render
    while @state != 'stopped'
      step
    end
  end
end

class View # renders calculator
  def initialize
    @clearCmd = Gem.win_platform? ?  "cls" :  "clear"
    @calculatorTop =
'
 ---------------
'
    @calculatorFace =
'|---------------
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
    system @clearCmd
    puts "Exiting..."
  end

  def render(inputChar = '', isValid = false, expression = '') # render view
    # system @clearCmd
    if inputChar != ''
      puts "#{isValid ? '' : 'Invalid key: ' + inputChar}"
    else
      puts "Enter an expression"
    end
    print @calculatorTop
    puts '| ' + expression
    print @calculatorFace
    puts
    puts 'Type keys shown above'
    puts 'q to quit'
  end
end

def main
  calcModel = Model.new
  calcView = View.new
  calcController = Controller.new(calcModel,calcView)
  calcController.start
end

main
