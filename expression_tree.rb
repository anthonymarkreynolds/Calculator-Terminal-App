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

    # get operator value
    operator =  expr[op_pos]

    # get left expression value
    left_expr = build_expr_tree(expr[0..(op_pos - 1)])

    # get right expressino value
    right_expr = build_expr_tree(expr[(op_pos+1)..-1])

    expr_tree = Tree.new(operator)
    expr_tree.insert_left(left_expr)
    expr_tree.insert_right(right_expr)

    # return the expression tree root node
    return expr_tree

  # else expr is a number
  else
    return expr
  end
end

def bin_fn(token,a,b)
  a = a.to_f
  b = b.to_f
  case token
  when '+'
    a + b
  when '-'
    a - b
  when '*'
    a * b
  when '/'
    a / b
  else
    'err'
  end
end

def evaluate(expr_tree)

  # if has child nodes (build_expr_tree is a complete tree, so; if one node exists there are two)
  unless expr_tree.left || expr_tree.right

  # return leaf value as float
  else
    expr_tree.value
  end
end

test = build_expr_tree(test_expr)

evaluate(test)
