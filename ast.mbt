enum Uop {
  Ref
  DeRef
} derive(Show)

///|
enum Bop {
  Add
  Mult
  Leq
  Sub
  Assign
} derive(Show)

///|
enum Expr {
  Unit
  Var(String)
  Int(Int)
  Bool(Bool)
  UniOp(Uop, Expr)
  Binop(Bop, Expr, Expr)
  Let(String, Expr, Expr)
  LetRec(String, Expr, Expr)
  If(Expr, Expr, Expr)
  App(Expr, Expr)
  Fun(String, Expr)
} derive(Show)
