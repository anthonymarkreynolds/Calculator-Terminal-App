# require 'system'
require 'io/console'

class Node

  attr_reader: :value
  attr_accessor: :left, :right

  def initialize(value)
    @value = value
    @left= nil
    @rigth = nil
  end

  def addNode(value)
    unless @left
      @left = value
    else
      @right = value
    end
  end

  def readNode
    puts @value
    puts @left
    puts @right
  end

end

class Model # crunchs numbers
  def initialize
    @expression = '' # store expression values
  end


  def evaluate # evaluate expression

    # split expression string by non-numbers (keeping delimiters)
    chunks = @expression.split(/([\+\-\/\(\)%\*])/).reject(&:empty?)

    # tokenize chunks
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
               'NUMBER'
             end
      {
        type: type,
        value: chunk
      }
    end

    # Build parse tree
    parseTree = tokens.reduce(Node.new(nil)) do |node, token|
      case token.type
      when 'NUMBER'
        node.addNode(Node.new(token))
      when 'MULTIPLY','DIVIDE'
        Node.new(token).addNode(node)
      end
    end
    puts parseTree
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
