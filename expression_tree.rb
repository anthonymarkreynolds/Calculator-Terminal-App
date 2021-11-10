test_expr = "1+2*3+4"

class Tree

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end

  def value
    return @value
  end

  def left
    @left
  end

  def right
    @right
  end

  def insert_left(value)
    @left = Tree.new(value)
  end

  def insert_right(value)
    @right = Tree.new(value)
  end
end

# build an expression tree
def build_expr_tree(expr)
  puts expr

  # if expression contains non-numbers (build a node)
  if ['+','-','*','/'].map{ |operator| expr.include?(operator) }.reduce(:|)

    # locate last, least precedent operator index
    add = expr.rindex('+')
    min = expr.rindex('-')

    # choose least precedent operator (addition or subtraction )
    if add || min
      op_pos = add && min ? [add, min].max : add || min

    # locate higher precedent operator index
    else
      mul = expr.rindex('*')
      div = expr.rindex('/')

      # choose least precedent operator (addition or subtraction )
      op_pos = mul && div ? [mul, div].max : mul || div
    end

    expr_tree = Tree.new(expr[op_pos])
    expr_tree.insert_left(build_expr_tree(expr[0..(op_pos - 1)]))
    expr_tree.insert_right( build_expr_tree(expr[(op_pos+1)..-1]))

    # return the expression tree root node

  # else expr is a number
  else
    return expr
  end
  expr_tree
end


def evaluate(expr_tree)

  if expr_tree.left
    if expr_tree.value == '+'
      evaluate(expr_tree.left) + evaluate(expr_tree.right)
    end
  else
    return expr_tree.value
  end
end

test = build_expr_tree('1+2+3+2')
test
# evaluate(test)
