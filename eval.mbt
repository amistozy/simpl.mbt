///|
using @hashmap {type HashMap}

///|
type Env = HashMap[String, Value]

///|
enum Value {
  Unit
  Int(Int)
  Bool(Bool)
  Loc(Ref[Value])
  Closure(String?, String, Expr, Env)
} derive(Show)

///|
fn lookup(x : String, env : Env) -> Value raise {
  match env.get(x) {
    Some(v) => v
    None => fail("Unbound variable \{x}")
  }
}

///|
fn Expr::eval(e : Expr, env : Env) -> Value raise {
  match e {
    Unit => Unit
    Bool(b) => Bool(b)
    Int(i) => Int(i)
    Var(x) => lookup(x, env)
    Fun(x, e) => Closure(None, x, e, env)
    UniOp(uop, e) => eval_uop(uop, e, env)
    Binop(bop, e1, e2) => eval_bop(bop, e1, e2, env)
    Let(x, e1, e2) => e2.eval(env.add(x, e1.eval(env)))
    LetRec(f, Fun(x, e1), e2) =>
      e2.eval(env.add(f, Closure(Some(f), x, e1, env)))
    LetRec(_) => fail("Right-hand side of letrec must be a function")
    If(e1, e2, e3) => eval_if(e1, e2, e3, env)
    App(e1, e2) => eval_app(e1, e2, env)
  }
}

///|
fn eval_uop(uop : Uop, e : Expr, env : Env) -> Value raise {
  match (uop, e.eval(env)) {
    (Ref, v) => Loc(Ref::new(v))
    (DeRef, Loc(r)) => r.val
    _ => fail("Operator and operand type mismatch")
  }
}

///|
fn eval_bop(bop : Bop, e1 : Expr, e2 : Expr, env : Env) -> Value raise {
  match (bop, e1.eval(env), e2.eval(env)) {
    (Add, Int(a), Int(b)) => Int(a + b)
    (Sub, Int(a), Int(b)) => Int(a - b)
    (Mult, Int(a), Int(b)) => Int(a * b)
    (Leq, Int(a), Int(b)) => Bool(a <= b)
    (Assign, Loc(r), v) => {
      r.val = v
      Unit
    }
    _ => fail("Operator and operand type mismatch")
  }
}

///|
fn eval_if(e1 : Expr, e2 : Expr, e3 : Expr, env : Env) -> Value raise {
  match e1.eval(env) {
    Bool(true) => e2.eval(env)
    Bool(false) => e3.eval(env)
    _ => fail("Guard of if must have type bool")
  }
}

///|
fn eval_app(e1 : Expr, e2 : Expr, env : Env) -> Value raise {
  match e1.eval(env) {
    Closure(None, x, e, defenv) => e.eval(defenv.add(x, e2.eval(env)))
    Closure(Some(name), x, e, defenv) as c =>
      e.eval(defenv.add(x, e2.eval(env)).add(name, c))
    _ => fail("Attempted to apply a non-function value")
  }
}
