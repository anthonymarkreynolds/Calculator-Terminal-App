testExpr = "1+2*3+4"

class Node
  def initialize(value = nil)
    @value = value
    @left = nil
    @right = nil
  end

  def insertLeft(value)
    @left = Node.new(value)
  end

  def insertRight(value)
    @right = Node.new(value)
  end
end

def exprTree(expr)
  puts expr

  # if expression contains non-numbers
  if ['+','-','*','/'].map{ |operator| expr.include?(operator) }.reduce(:|)
    add = expr.rindex('+')
    min = expr.rindex('-')

    if add || min
      op = add && min ? [add, min].max : add || min
    else
      mul = expr.rindex('*')
      div = expr.rindex('/')
      op = mul && div ? [mul, div].max : mul || div
    end

    puts expr[op]
    left = exprTree(expr[0..(op - 1)])
    right = exprTree(expr[(op+1)..-1])
    return Node.new(expr[op]).insertLeft(left).insertRight(right)

  else
    return expr
  end
end

def evaluate(exprTree)

end

puts exprTree(testExpr)
