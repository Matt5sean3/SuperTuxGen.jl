
# Use Julia's internal syntax trees as the representation for the SuperTux files
function write_scheme(io::IO, elem)
  write(io, elem)
end

function write_scheme(io::IO, expr::Expr)
  if(expr.head == :call || expr.head == :tuple)
    # tuples and calls are written the same here
    write(io, "(")
    for elem in expr.args
      write_scheme(io, elem)
      write(io, " ")
    end
    write(io, ")")
  elseif(expr.head == :block)
    # Scheme doesn't have blocks the way Julia does
    # Just recurse and write the first entry that is an expression
    for arg in expr.args
      if isa(arg, Expr) && arg.head != :line
        write_scheme(io, arg)
        break
      end
    end
  else
    # Unrecognized contructs show up here
    head = expr.head
    write(io, "<$head>")
  end
end

function write_scheme(io::IO, str::String)
  print(io, "\"$str\"")
end

function write_scheme(io::IO, num::Number)
  print(io, num)
end

